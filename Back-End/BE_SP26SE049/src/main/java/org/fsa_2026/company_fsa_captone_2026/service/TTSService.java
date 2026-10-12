package org.fsa_2026.company_fsa_captone_2026.service;

import java.util.Map;
import org.fsa_2026.company_fsa_captone_2026.exception.ApiException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TTSService {
    private static final String FPT_API_URL = "https://api.fpt.ai/hmi/tts/v5";
    private static final String FPT_API_KEY = "oZO8MheKtxmn0JAVKiaeURTubrDtOwdp";

    // In-memory cache to save API quota and make repeated words instant
    private final Map<String, Map<String, Object>> cache = new java.util.concurrent.ConcurrentHashMap<>();

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map<String, Object> synthesize(String text, String voice) {
        if (text == null || text.isBlank()) {
            return Map.of("error", 1, "message", "Văn bản không được để trống", "async", "");
        }

        String safeVoice = (voice != null && !voice.isBlank()) ? voice.trim() : "banmai";
        String cacheKey = safeVoice + "::" + text.trim().toLowerCase();

        if (cache.containsKey(cacheKey)) {
            log.info("Returning cached TTS for key: {}", cacheKey);
            return cache.get(cacheKey);
        }

        try {
            RestTemplate restTemplate = new RestTemplate();
            restTemplate.getMessageConverters()
                    .add(0, new org.springframework.http.converter.StringHttpMessageConverter(
                            java.nio.charset.StandardCharsets.UTF_8));
            HttpHeaders headers = new HttpHeaders();
            headers.set("api-key", FPT_API_KEY);
            headers.set("api_key", FPT_API_KEY);
            headers.set("Content-Type", "text/plain; charset=utf-8");
            headers.set("voice", safeVoice);
            headers.set("speed", "");
            headers.set("prosody", "1");

            // FPT AI requires at least 3 characters; pad short text with spaces
            String trimmed = text.trim();
            String paddedText = trimmed.length() < 3 ? trimmed + " ".repeat(3 - trimmed.length()) : trimmed;
            HttpEntity<String> entity = new HttpEntity<>(paddedText, headers);
            log.info("Calling FPT AI TTS for text: {}", trimmed.substring(0, Math.min(trimmed.length(), 20)) + "...");

            ResponseEntity<Map> response = restTemplate.exchange(FPT_API_URL, HttpMethod.POST, entity, Map.class);
            Map body = response.getBody();

            // Wait for the async url to be ready to avoid CORS errors on frontend
            if (body != null && body.containsKey("async") && body.get("async") != null) {
                String asyncUrl = (String) body.get("async");
                if (asyncUrl != null && !asyncUrl.isBlank()) {
                    pollAudioUrl(asyncUrl);
                    cache.put(cacheKey, body);
                    return body;
                }
            }

            return body != null ? body : Map.of("error", 1, "message", "Empty response from FPT AI", "async", "");
        } catch (Exception e) {
            log.warn("FPT AI TTS Rate Limit or Error for '{}' (voice {}): {}", text, safeVoice, e.getMessage());
            // Gracefully return error map so frontend can fallback to Web Speech API immediately without 500 error
            return Map.of("error", 1, "message", "FPT rate limit: " + e.getMessage(), "async", "");
        }
    }

    // Helper to poll until FPT.AI finishes processing
    private void pollAudioUrl(String url) {
        RestTemplate restTemplate = new RestTemplate();
        int retries = 0;
        int maxRetries = 20; // Maximum wait ~20 seconds
        while (retries < maxRetries) {
            try {
                ResponseEntity<String> res = restTemplate.exchange(url, HttpMethod.HEAD, null, String.class);
                if (res.getStatusCode().is2xxSuccessful()) {
                    log.info("Audio processed successfully at {}", url);
                    return; // Ready!
                }
            } catch (Exception ignored) {
                // Ignore 404 or other errors while processing
            }
            try {
                Thread.sleep(1000); // Check every second
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
            retries++;
        }
        log.warn("Timeout waiting for FPT.AI to process audio: {}", url);
    }
}
