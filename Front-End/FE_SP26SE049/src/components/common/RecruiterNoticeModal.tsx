import React, { useState, useEffect, useRef } from 'react'
import {
  Server,
  Cloud,
  Database,
  Cpu,
  Zap,
  Activity,
  CheckCircle2,
  AlertTriangle,
  Copy,
  Check,
  LogIn,
  RefreshCw,
  X,
  Info,
  Sparkles,
  Shield,
  UserCheck,
  GraduationCap,
  Award,
  BookOpen
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { message } from 'antd'
import apiClient from '../../services/apiClient'

export type ServerStatusType = 'checking' | 'waking' | 'online'

interface RecruiterNoticeModalProps {
  isOpen: boolean
  onClose: () => void
  onQuickLogin?: (email: string, password: string) => void
}

export const RecruiterNoticeModal: React.FC<RecruiterNoticeModalProps> = ({
  isOpen,
  onClose,
  onQuickLogin,
}) => {
  const [activeTab, setActiveTab] = useState<'accounts' | 'server' | 'ai'>('accounts')
  const [status, setStatus] = useState<ServerStatusType>('checking')
  const [isPinging, setIsPinging] = useState(false)
  const [copiedAccount, setCopiedAccount] = useState<string | null>(null)
  const [countdown, setCountdown] = useState<number>(45)
  const countdownTimerRef = useRef<ReturnType<typeof setInterval> | null>(null)

  const DEMO_ACCOUNTS = [
    {
      role: 'Học viên 1 (Showcase Full Màn)',
      email: 'student@fsa.com',
      password: 'User@123',
      badge: 'ĐÃ MỞ KHÓA TOÀN BỘ LỘ TRÌNH',
      badgeColor: 'bg-emerald-100 text-emerald-800 border-emerald-400',
      description:
        'Tài khoản hoàn thiện 100% tiến độ 3 miền Bắc - Trung - Nam (240 bài học, 675 sao, 10 huy hiệu). Dành cho Nhà tuyển dụng muốn xem nhanh giao diện, dashboard, tủ huy hiệu và tất cả dạng bài tập.',
      icon: Award,
      buttonColor: 'bg-sky-400 hover:bg-sky-500',
    },
    {
      role: 'Học viên 2 (Trải nghiệm Mới tinh)',
      email: 'tested_student@fsa.com',
      password: 'User@123',
      badge: 'LỘ TRÌNH TRỐNG ĐỂ TRẢI NGHIỆM',
      badgeColor: 'bg-amber-100 text-amber-800 border-amber-400',
      description:
        'Tài khoản mới tạo hoàn toàn (0 sao, 0 XP, chưa làm test đầu vào). Dành cho Nhà tuyển dụng muốn kiểm thử luồng người dùng mới: Làm Entry Test chẩn đoán giọng miền -> Nhận phân tích -> Mở khóa bài học đầu tiên.',
      icon: BookOpen,
      buttonColor: 'bg-amber-400 hover:bg-amber-500',
    },
  ]

  const checkServerStatus = async (isManual = false) => {
    if (isPinging && !isManual) return
    setIsPinging(true)
    try {
      // Send a lightweight public check
      const res = await apiClient.get('/public/system-configs', { timeout: 15000 })
      if (res && (res.status === 200 || res.data)) {
        setStatus('online')
        if (countdownTimerRef.current) clearInterval(countdownTimerRef.current)
        if (isManual) message.success('🟢 Máy chủ Backend & Database đang hoạt động bình thường!')
      } else {
        setStatus('waking')
      }
    } catch (err) {
      console.warn('Ping check result:', err)
      setStatus('waking')
    } finally {
      setIsPinging(false)
    }
  }

  useEffect(() => {
    if (isOpen) {
      checkServerStatus()
      countdownTimerRef.current = setInterval(() => {
        setCountdown((prev) => (prev <= 1 ? 1 : prev - 1))
      }, 1000)
    }
    return () => {
      if (countdownTimerRef.current) clearInterval(countdownTimerRef.current)
    }
  }, [isOpen])

  const copyToClipboard = (text: string, label: string) => {
    navigator.clipboard.writeText(text)
    setCopiedAccount(label)
    message.success(`Đã sao chép ${label}`)
    setTimeout(() => setCopiedAccount(null), 2500)
  }

  const handleLoginClick = (acc: (typeof DEMO_ACCOUNTS)[0]) => {
    if (onQuickLogin) {
      onQuickLogin(acc.email, acc.password)
      onClose()
    } else {
      copyToClipboard(acc.email, 'Email')
    }
  }

  if (!isOpen) return null

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-5 bg-black/60 backdrop-blur-sm animate-fadeIn">
        <motion.div
          initial={{ scale: 0.92, opacity: 0, y: 20 }}
          animate={{ scale: 1, opacity: 1, y: 0 }}
          exit={{ scale: 0.92, opacity: 0, y: 20 }}
          transition={{ type: 'spring', damping: 25, stiffness: 250 }}
          className="w-full max-w-2xl bg-white border-[3.5px] border-slate-900 rounded-[2.5rem] shadow-[12px_12px_0_#1f2937] overflow-hidden flex flex-col max-h-[92vh] font-nunito"
        >
          {/* Header */}
          <div className="bg-[#49B6E5] border-b-[3.5px] border-slate-900 p-5 sm:p-6 text-white relative">
            <button
              onClick={onClose}
              className="absolute top-5 right-5 w-9 h-9 rounded-xl bg-white/20 hover:bg-white/30 border-[2px] border-slate-900 flex items-center justify-center text-slate-900 transition-all active:scale-95 shadow-[2px_2px_0_#1f2937]"
            >
              <X size={18} strokeWidth={3} />
            </button>

            <div className="flex items-center gap-2 mb-1.5">
              <span className="px-3 py-0.5 rounded-full bg-amber-300 text-slate-900 font-black text-[11px] uppercase tracking-wider border-[1.5px] border-slate-900 shadow-[1px_1px_0_#1f2937] flex items-center gap-1">
                <Sparkles size={12} /> Hướng Dẫn Nhà Tuyển Dụng
              </span>
              <div className="flex items-center gap-1.5 bg-white/20 backdrop-blur-sm px-2.5 py-0.5 rounded-full border border-white/30 text-[11px] font-bold">
                <span
                  className={`w-2 h-2 rounded-full ${
                    status === 'online'
                      ? 'bg-emerald-400 animate-pulse'
                      : status === 'waking'
                      ? 'bg-amber-400 animate-ping'
                      : 'bg-slate-300'
                  }`}
                />
                <span>
                  {status === 'online'
                    ? 'Máy chủ Online'
                    : status === 'waking'
                    ? `Đang khởi động (${countdown}s)`
                    : 'Đang kiểm tra'}
                </span>
              </div>
            </div>

            <h2 className="text-xl sm:text-2xl font-black uppercase tracking-tight text-slate-900">
              SpeakVN — Trợ Lý Luyện Ngữ Âm 3 Miền
            </h2>
            <p className="text-xs sm:text-sm text-slate-800 font-bold mt-1 max-w-lg leading-relaxed">
              Dự án được triển khai trên nền tảng Cloud (Vercel, Render Free Tier &amp; Neon Postgres).
              Dưới đây là thông tin trải nghiệm nhanh cho hội đồng tuyển dụng.
            </p>
          </div>

          {/* Navigation Tabs */}
          <div className="flex border-b-[2.5px] border-slate-900 bg-slate-50 px-4 pt-3 gap-2">
            <button
              onClick={() => setActiveTab('accounts')}
              className={`px-4 py-2 font-black text-xs uppercase tracking-wider rounded-t-xl border-t-[2.5px] border-x-[2.5px] border-slate-900 transition-all flex items-center gap-1.5 ${
                activeTab === 'accounts'
                  ? 'bg-white text-slate-900 shadow-[2px_-2px_0_#1f2937] -mb-[2.5px] pb-2.5'
                  : 'bg-slate-200 text-slate-600 hover:bg-slate-100 border-transparent'
              }`}
            >
              <UserCheck size={14} /> Tài khoản Demo (Test)
            </button>
            <button
              onClick={() => setActiveTab('server')}
              className={`px-4 py-2 font-black text-xs uppercase tracking-wider rounded-t-xl border-t-[2.5px] border-x-[2.5px] border-slate-900 transition-all flex items-center gap-1.5 ${
                activeTab === 'server'
                  ? 'bg-white text-slate-900 shadow-[2px_-2px_0_#1f2937] -mb-[2.5px] pb-2.5'
                  : 'bg-slate-200 text-slate-600 hover:bg-slate-100 border-transparent'
              }`}
            >
              <Server size={14} /> Cloud &amp; Cold-Start
            </button>
            <button
              onClick={() => setActiveTab('ai')}
              className={`px-4 py-2 font-black text-xs uppercase tracking-wider rounded-t-xl border-t-[2.5px] border-x-[2.5px] border-slate-900 transition-all flex items-center gap-1.5 ${
                activeTab === 'ai'
                  ? 'bg-white text-slate-900 shadow-[2px_-2px_0_#1f2937] -mb-[2.5px] pb-2.5'
                  : 'bg-slate-200 text-slate-600 hover:bg-slate-100 border-transparent'
              }`}
            >
              <Cpu size={14} /> Kiến trúc AI 3 Tầng
            </button>
          </div>

          {/* Content Body */}
          <div className="p-5 sm:p-6 overflow-y-auto space-y-4">
            {/* TAB 1: DEMO ACCOUNTS */}
            {activeTab === 'accounts' && (
              <div className="space-y-4">
                <div className="p-3 bg-sky-50 border-[2px] border-slate-900 rounded-2xl flex items-center justify-between text-xs font-bold text-slate-700">
                  <div className="flex items-center gap-2">
                    <Zap size={16} className="text-amber-500 fill-amber-500 shrink-0" />
                    <span>Mật khẩu chung cho tất cả tài khoản trải nghiệm:</span>
                  </div>
                  <span className="font-black bg-white px-2.5 py-1 rounded-xl border border-slate-400 text-slate-900 tracking-wider">
                    User@123
                  </span>
                </div>

                <div className="grid grid-cols-1 gap-3.5">
                  {DEMO_ACCOUNTS.map((acc, idx) => {
                    const Icon = acc.icon
                    return (
                      <div
                        key={idx}
                        className="p-4 bg-white border-[2.5px] border-slate-900 rounded-2xl shadow-[4px_4px_0_#1f2937] flex flex-col justify-between gap-3"
                      >
                        <div>
                          <div className="flex items-center justify-between gap-2 mb-1.5">
                            <div className="flex items-center gap-2">
                              <div className="w-8 h-8 rounded-xl bg-slate-900 text-amber-300 flex items-center justify-center border border-slate-800">
                                <Icon size={16} />
                              </div>
                              <h3 className="font-black text-slate-900 text-sm">{acc.role}</h3>
                            </div>
                            <span
                              className={`text-[9.5px] font-black uppercase tracking-wider px-2 py-0.5 rounded-lg border ${acc.badgeColor}`}
                            >
                              {acc.badge}
                            </span>
                          </div>
                          <p className="text-xs text-slate-600 font-bold leading-relaxed">{acc.description}</p>
                        </div>

                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pt-2 border-t border-slate-200">
                          <div className="flex items-center gap-2 text-xs font-black text-slate-800">
                            <span className="text-slate-500 font-semibold">Tài khoản:</span>
                            <code className="bg-slate-100 px-2 py-0.5 rounded-lg border border-slate-300">
                              {acc.email}
                            </code>
                          </div>

                          <div className="flex items-center gap-2">
                            <button
                              onClick={() => copyToClipboard(`${acc.email} | ${acc.password}`, acc.role)}
                              className="px-3 py-1.5 bg-white border-[2px] border-slate-900 rounded-xl text-xs font-black text-slate-800 shadow-[2px_2px_0_#1f2937] hover:bg-slate-50 active:translate-y-0.5 transition-all flex items-center gap-1"
                            >
                              {copiedAccount === acc.role ? <Check size={12} className="text-emerald-600" /> : <Copy size={12} />}
                              <span>{copiedAccount === acc.role ? 'Đã chép' : 'Sao chép'}</span>
                            </button>

                            <button
                              onClick={() => handleLoginClick(acc)}
                              className={`px-4 py-1.5 ${acc.buttonColor} border-[2px] border-slate-900 rounded-xl text-xs font-black text-slate-900 shadow-[2px_2px_0_#1f2937] active:translate-y-0.5 transition-all flex items-center gap-1.5`}
                            >
                              <LogIn size={13} strokeWidth={2.5} />
                              <span>Đăng nhập ngay</span>
                            </button>
                          </div>
                        </div>
                      </div>
                    )
                  })}
                </div>

                {/* Role Admin/Educator note */}
                <div className="p-3.5 bg-slate-100 border-[2px] border-slate-900 rounded-2xl flex items-start gap-2.5 text-xs text-slate-700">
                  <Shield size={18} className="text-indigo-600 shrink-0 mt-0.5" />
                  <div>
                    <span className="font-black text-slate-900 block mb-0.5">
                      Lưu ý về tài khoản Quản trị &amp; Giảng viên:
                    </span>
                    <p className="font-bold text-[11px] leading-relaxed text-slate-600">
                      Để bảo vệ dữ liệu cấu hình hệ thống trên Production, các tài khoản{' '}
                      <code className="bg-white px-1.5 py-0.5 rounded border border-slate-300 text-slate-800 font-black">
                        admin@fsa.com
                      </code>{' '}
                      và{' '}
                      <code className="bg-white px-1.5 py-0.5 rounded border border-slate-300 text-slate-800 font-black">
                        educator@fsa.com
                      </code>{' '}
                      được ẩn khỏi thanh chọn nhanh công khai (mật khẩu chuẩn:{' '}
                      <span className="font-black text-slate-900">User@123</span>). Hội đồng tuyển dụng có thể nhập trực tiếp
                      để kiểm tra các trang Dashboard quản trị nội bộ.
                    </p>
                  </div>
                </div>
              </div>
            )}

            {/* TAB 2: SERVER & COLD START */}
            {activeTab === 'server' && (
              <div className="space-y-3.5">
                <div className="p-4 bg-amber-50 border-[2.5px] border-slate-900 rounded-2xl shadow-[4px_4px_0_#1f2937]">
                  <div className="flex items-center gap-2 mb-2 text-slate-900 font-black text-sm">
                    <Cloud className="text-amber-500 shrink-0" size={18} />
                    <span>Lưu ý về Máy chủ Cloud Free Tier (Render &amp; Neon):</span>
                  </div>
                  <ul className="text-xs text-slate-700 font-bold space-y-2 list-disc pl-5 leading-relaxed">
                    <li>
                      <strong className="text-slate-900">Render Free Web Service:</strong> Tự động rơi vào trạng thái ngủ
                      (Sleep) sau 15 phút không có lượt truy cập. Khi có yêu cầu mới, máy chủ cần khoảng{' '}
                      <span className="text-amber-600 underline font-black">30 - 50 giây</span> để nạp container Spring Boot và
                      kết nối cơ sở dữ liệu.
                    </li>
                    <li>
                      <strong className="text-slate-900">Neon PostgreSQL Serverless:</strong> Tự động kích hoạt cơ chế
                      Auto-suspend và kết nối qua Connection Pooler an toàn.
                    </li>
                    <li>
                      Nếu quý Nhà tuyển dụng thấy thao tác đầu tiên hơi chậm, xin vui lòng đợi giây lát hoặc bấm nút kiểm tra
                      bên dưới. Sau khi máy chủ thức dậy, mọi thao tác sẽ phản hồi mượt mà trong &lt; 200ms.
                    </li>
                  </ul>
                </div>

                <div className="p-4 bg-white border-[2.5px] border-slate-900 rounded-2xl shadow-[4px_4px_0_#1f2937] flex items-center justify-between">
                  <div>
                    <h4 className="font-black text-slate-900 text-xs uppercase tracking-wider mb-1">
                      Kiểm tra trạng thái máy chủ tức thì:
                    </h4>
                    <p className="text-[11px] font-bold text-slate-500">
                      Gửi tín hiệu kiểm tra đến Endpoint Back-End để đánh thức container.
                    </p>
                  </div>
                  <button
                    onClick={() => checkServerStatus(true)}
                    disabled={isPinging}
                    className="px-4 py-2 bg-emerald-400 hover:bg-emerald-500 border-[2px] border-slate-900 rounded-xl font-black text-xs text-slate-900 shadow-[2px_2px_0_#1f2937] active:translate-y-0.5 transition-all flex items-center gap-1.5 disabled:opacity-50"
                  >
                    <RefreshCw size={14} className={isPinging ? 'animate-spin' : ''} />
                    <span>{isPinging ? 'Đang kiểm tra...' : 'Kiểm tra ngay'}</span>
                  </button>
                </div>
              </div>
            )}

            {/* TAB 3: AI ARCHITECTURE */}
            {activeTab === 'ai' && (
              <div className="space-y-3">
                <div className="p-3.5 bg-emerald-50 border-[2px] border-slate-900 rounded-2xl">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-base">🎯</span>
                    <h4 className="font-black text-slate-900 text-xs uppercase tracking-wider">
                      Tầng 1: Rule-based &amp; Ma Trận Âm Học IPA (Phonetic Analysis)
                    </h4>
                  </div>
                  <p className="text-[11px] font-bold text-slate-600 leading-relaxed">
                    Chuẩn hóa ma trận đối chiếu 6 cặp âm ngọng đặc trưng 3 miền: N/L (Bắc), TR/CH, S/X (Trung), D/GI/R,
                    V/D (Nam) và cặp dấu Thanh Hỏi/Ngã. So khớp nguyên âm, phụ âm và thanh điệu mà không phụ thuộc hoàn toàn vào cloud.
                  </p>
                </div>

                <div className="p-3.5 bg-sky-50 border-[2px] border-slate-900 rounded-2xl">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-base">🎙️</span>
                    <h4 className="font-black text-slate-900 text-xs uppercase tracking-wider">
                      Tầng 2: Xử Lý Tín Hiệu Âm Thanh &amp; ASR Mô Hình Tiếng Việt
                    </h4>
                  </div>
                  <p className="text-[11px] font-bold text-slate-600 leading-relaxed">
                    Thu âm và lọc ồn trực tiếp tại trình duyệt (Web Audio API), chuyển đổi PCM/WAV 16kHz chuẩn phòng thu và
                    chạy qua mô hình nhận diện giọng nói tiếng Việt chuyên sâu huấn luyện trên Hugging Face Space + FPT.AI TTS 3 miền.
                  </p>
                </div>

                <div className="p-3.5 bg-purple-50 border-[2px] border-slate-900 rounded-2xl">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-base">🤖</span>
                    <h4 className="font-black text-slate-900 text-xs uppercase tracking-wider">
                      Tầng 3: LLM Trợ Lý Sư Phạm (Groq LLaMA 3.3-70B Versatile)
                    </h4>
                  </div>
                  <p className="text-[11px] font-bold text-slate-600 leading-relaxed">
                    Đóng vai trò chuyên gia sư phạm phân tích khẩu hình, giải thích lý do sai của từng đáp án trắc nghiệm
                    và hướng dẫn uốn cong lưỡi, đẩy hơi theo thời gian thực (&lt; 600ms latency).
                  </p>
                </div>
              </div>
            )}
          </div>

          {/* Footer */}
          <div className="p-4 bg-slate-50 border-t-[2.5px] border-slate-900 flex items-center justify-between">
            <span className="text-[11px] font-black text-slate-500">
              SpeakVN Capstone Project — 2026
            </span>
            <button
              onClick={onClose}
              className="px-5 py-2 bg-slate-900 text-white rounded-xl font-black text-xs uppercase tracking-wider hover:bg-slate-800 active:translate-y-0.5 transition-all border border-slate-900 shadow-[2px_2px_0_#49B6E5]"
            >
              Đã Hiểu &amp; Tiếp Tục
            </button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  )
}

export default RecruiterNoticeModal
