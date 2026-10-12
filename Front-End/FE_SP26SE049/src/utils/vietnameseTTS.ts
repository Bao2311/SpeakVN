import { apiClient } from '../services/apiClient';

// Pre-warm Web Speech API voices
if (typeof window !== 'undefined' && 'speechSynthesis' in window) {
  window.speechSynthesis.getVoices();
  if (window.speechSynthesis.onvoiceschanged !== undefined) {
    window.speechSynthesis.onvoiceschanged = () => {
      window.speechSynthesis.getVoices();
    };
  }
}

/**
 * Native browser speech synthesis for Vietnamese
 * Guaranteed to work offline, with zero rate limits and instant playback
 */
export const speakNativeVietnamese = (text: string, voiceType?: string): Promise<boolean> => {
  return new Promise((resolve) => {
    if (typeof window === 'undefined' || !('speechSynthesis' in window)) {
      resolve(false);
      return;
    }

    try {
      window.speechSynthesis.cancel();
      const clean = text?.trim();
      if (!clean) {
        resolve(false);
        return;
      }

      const utterance = new SpeechSynthesisUtterance(clean);
      utterance.lang = 'vi-VN';
      utterance.rate = 0.85; // Slightly slower pace for learners to hear clearly
      utterance.pitch = 1.0;

      const voices = window.speechSynthesis.getVoices();
      // Try to match Vietnamese voice
      const viVoice = voices.find(
        (v) =>
          v.lang.toLowerCase().includes('vi') ||
          v.name.toLowerCase().includes('vietnam') ||
          v.name.toLowerCase().includes('vietnamese')
      );
      if (viVoice) {
        utterance.voice = viVoice;
      }

      utterance.onend = () => resolve(true);
      utterance.onerror = (e) => {
        console.warn('[WebSpeech] utterance error:', e);
        resolve(false);
      };

      window.speechSynthesis.cancel();
      window.speechSynthesis.resume();
      window.speechSynthesis.speak(utterance);
    } catch (err) {
      console.warn('[WebSpeech] exception:', err);
      resolve(false);
    }
  });
};

/**
 * Universal Audio Player with Multi-layer Fallback:
 * 1. Pre-recorded audio URL (if valid)
 * 2. FPT.AI TTS (via backend proxy)
 * 3. Browser Native Web Speech API (vi-VN)
 *
 * Guarantees that users ALWAYS hear audio in exercises and quizzes.
 */
export const playVietnameseAudio = async (options: {
  text?: string | null;
  voice?: string;
  audioUrl?: string | null;
}): Promise<boolean> => {
  const { text, voice = 'banmai', audioUrl } = options;

  // 1. If audioUrl exists, try playing it first
  if (audioUrl && audioUrl.trim()) {
    try {
      const audioSuccess = await new Promise<boolean>((resolve) => {
        const audio = new Audio(audioUrl.trim());
        audio.onended = () => resolve(true);
        audio.onerror = () => resolve(false);
        audio.play().then(() => resolve(true)).catch(() => resolve(false));
      });
      if (audioSuccess) return true;
    } catch (_) {
      // Audio url failed, proceed to TTS
    }
  }

  const cleanText = text?.trim();
  if (!cleanText) return false;

  // 2. Try Backend TTS proxy (FPT.AI)
  try {
    const res: any = await apiClient.post('/ai/tts', { text: cleanText, voice });
    const data = res?.data || res;
    if (data && data.async && typeof data.async === 'string' && data.async.trim().length > 0) {
      const played = await new Promise<boolean>((resolve) => {
        const audio = new Audio(data.async);
        audio.onended = () => resolve(true);
        audio.onerror = () => resolve(false);
        audio.play().then(() => resolve(true)).catch(() => resolve(false));
      });
      if (played) return true;
    }
  } catch (err) {
    console.warn('[TTS] Backend TTS proxy failed, switching to native speech:', err);
  }

  // 3. Fallback to Web Speech API
  return await speakNativeVietnamese(cleanText, voice);
};
