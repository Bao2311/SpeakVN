import React, { useState, useCallback } from 'react'
import { Form, Input, Button, message, Checkbox } from 'antd'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../../core/auth/AuthContext'
import { getLearnerOnboardingPath } from '../../utils/onboarding'
import { Lock, Mail, Home, Sparkles, User, ArrowRight, Zap, CheckCircle2, Shield, GraduationCap, Backpack, Award, Users, Mic } from 'lucide-react'
import { GoogleOAuthProvider, useGoogleLogin } from '@react-oauth/google'
import { motion } from 'framer-motion'
import { DoodleLoading } from '../../components/ui/DoodleLoading'
import RecruiterNoticeModal from '../../components/common/RecruiterNoticeModal'

const GOOGLE_CLIENT_ID = '1086072031174-fk0iepl3k13dol2u53tjsueo3c3vq70j.apps.googleusercontent.com'
const FACEBOOK_APP_ID = '1169205748542841'
const FB_REDIRECT_URI = `${window.location.origin}/auth/facebook/callback`

const passwordRules = [
  { required: true, message: 'Vui lòng nhập mật khẩu!' },
  { min: 6, message: 'Mật khẩu phải có ít nhất 6 ký tự' },
]

function LoginForm() {
  const navigate = useNavigate()
  const { login, socialLogin } = useAuth()
  const [form] = Form.useForm()
  const [loading, setLoading] = useState(false)
  const [googleLoading, setGoogleLoading] = useState(false)
  const [facebookLoading, setFacebookLoading] = useState(false)
  const [selectedRole, setSelectedRole] = useState(null)
  const [showRecruiterModal, setShowRecruiterModal] = useState(false)

  // Auto-open modal once per session for recruiters
  React.useEffect(() => {
    const hasSeen = sessionStorage.getItem('speakvn_recruiter_notice_seen')
    if (!hasSeen) {
      const timer = setTimeout(() => {
        setShowRecruiterModal(true)
        sessionStorage.setItem('speakvn_recruiter_notice_seen', 'true')
      }, 600)
      return () => clearTimeout(timer)
    }
  }, [])

  const handleQuickSelect = (email, role, customPassword = 'User@123') => {
    setSelectedRole(role)
    form.setFieldsValue({
      email,
      password: customPassword,
      remember: true,
    })
    message.success(`Đã chọn tài khoản ${role}: ${email}`)
  }

  const handleModalQuickLogin = (email, password) => {
    form.setFieldsValue({
      email,
      password,
      remember: true,
    })
    onFinish({ email, password, remember: true })
  }

  const navigateByRole = useCallback((session) => {
    if (session.user.role === 'ADMIN') {
      navigate('/admin', { replace: true })
    } else if (session.user.role === 'EDUCATOR') {
      navigate('/educator', { replace: true })
    } else {
      navigate(getLearnerOnboardingPath(session.user), { replace: true })
    }
  }, [navigate])

  const googleLogin = useGoogleLogin({
    flow: 'implicit',
    scope: 'openid email profile',
    onSuccess: async (tokenResponse) => {
      setGoogleLoading(true)
      try {
        const session = await socialLogin('GOOGLE', tokenResponse.access_token)
        message.success(`Chào mừng ${session.user.fullName}!`)
        navigateByRole(session)
      } catch (err) {
        const backendMsg = err?.response?.data?.message
        message.error(backendMsg ?? err?.message ?? 'Đăng nhập Google thất bại. Vui lòng thử lại.')
      } finally {
        setGoogleLoading(false)
      }
    },
    onError: (err) => {
      console.error('Google login error:', err)
      message.error('Google đăng nhập bị hủy bỏ hoặc xảy ra lỗi.')
    },
  })

  const handleGoogleLogin = () => {
    googleLogin()
  }

  const handleFacebookLogin = () => {
    setFacebookLoading(true)
    const fbOAuthURL = `https://www.facebook.com/v19.0/dialog/oauth?` +
      `client_id=${FACEBOOK_APP_ID}` +
      `&redirect_uri=${encodeURIComponent(FB_REDIRECT_URI)}` +
      `&scope=public_profile,email` +
      `&response_type=token` +
      `&display=popup`

    const width = 580
    const height = 600
    const left = (window.screen.width - width) / 2
    const top = (window.screen.height - height) / 2
    const popup = window.open(
      fbOAuthURL,
      'facebook-login',
      `width=${width},height=${height},left=${left},top=${top},toolbar=no,menubar=no,scrollbars=yes`
    )

    if (!popup) {
      message.error('Popup bị chặn! Vui lòng cho phép popup cho trang này.')
      setFacebookLoading(false)
      return
    }

    const pollTimer = setInterval(() => {
      try {
        if (!popup || popup.closed) {
          clearInterval(pollTimer)
          setFacebookLoading(false)
          return
        }

        const currentUrl = popup.location.href
        if (currentUrl.includes(FB_REDIRECT_URI) || currentUrl.includes('access_token=')) {
          clearInterval(pollTimer)

          const hash = popup.location.hash.substring(1)
          const params = new URLSearchParams(hash)
          const accessToken = params.get('access_token')

          popup.close()

          if (accessToken) {
            socialLogin('FACEBOOK', accessToken)
              .then((session) => {
                message.success(`Chào mừng ${session.user.fullName}!`)
                navigateByRole(session)
              })
              .catch((err) => {
                const backendMsg = err?.response?.data?.message
                message.error(backendMsg ?? err?.message ?? 'Đăng nhập Facebook thất bại.')
              })
              .finally(() => {
                setFacebookLoading(false)
              })
          } else {
            message.error('Không nhận được token từ Facebook.')
            setFacebookLoading(false)
          }
        }
      } catch {
        // Cross-origin restriction before redirect - ignore
      }
    }, 500)
  }

  const onFinish = async (values) => {
    setLoading(true)
    try {
      const session = await login(values.email, values.password, values.remember)
      navigateByRole(session)
    } catch (err) {
      if (err?.status === 403 || err?.response?.status === 403) {
        message.warning('Tài khoản chưa được xác thực. Vui lòng xác thực email.')
        navigate('/verify-email', { state: { email: values.email } })
      } else {
        message.error(err?.message ?? 'Thông tin đăng nhập không hợp lệ')
      }
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-[#fbf6ef] flex items-center justify-center font-nunito">
        <DoodleLoading message="Đang đưa bạn vào hệ thống..." />
      </div>
    )
  }

  return (
    <div className="min-h-screen w-full bg-[#fbf6ef] flex flex-col justify-between p-4 sm:p-6 lg:p-8 font-nunito relative overflow-hidden">

      {/* Background Ambience & Doodle Accents */}
      <div className="absolute inset-0 pointer-events-none opacity-40">
        <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(circle at 20px 20px, #cbd5e1 1.5px, transparent 0)', backgroundSize: '40px 40px' }} />
      </div>

      {/* Floating Feature Badges for wide screens */}
      <div className="hidden 2xl:flex flex-col gap-4 absolute top-28 left-8 pointer-events-none z-10 max-w-xs animate-float">
        <div className="bg-white/95 backdrop-blur-sm border-[2.5px] border-slate-900 rounded-2xl p-4 shadow-[5px_5px_0_#1f2937]">
          <div className="flex items-center gap-2.5 mb-1.5">
            <span className="text-xl">🇻🇳</span>
            <span className="font-black text-slate-900 text-xs uppercase tracking-wider">3 Vùng Miền Ngữ Âm</span>
          </div>
          <p className="text-[11px] text-slate-600 font-bold leading-relaxed">
            Học chuẩn khẩu hình & ngữ điệu đặc trưng Bắc, Trung, Nam.
          </p>
        </div>

        <div className="bg-white/95 backdrop-blur-sm border-[2.5px] border-slate-900 rounded-2xl p-4 shadow-[5px_5px_0_#1f2937]">
          <div className="flex items-center gap-2.5 mb-1.5">
            <span className="text-xl">🤖</span>
            <span className="font-black text-slate-900 text-xs uppercase tracking-wider">AI Phân Tích Giọng Nói</span>
          </div>
          <p className="text-[11px] text-slate-600 font-bold leading-relaxed">
            Nhận diện âm sai & hướng dẫn uốn lưỡi tức thì.
          </p>
        </div>
      </div>

      <div className="hidden 2xl:flex flex-col gap-4 absolute bottom-20 right-8 pointer-events-none z-10 max-w-xs animate-float" style={{ animationDelay: '1.5s' }}>
        <div className="bg-white/95 backdrop-blur-sm border-[2.5px] border-slate-900 rounded-2xl p-4 shadow-[5px_5px_0_#1f2937]">
          <div className="flex items-center gap-2.5 mb-1.5">
            <span className="text-xl">🏆</span>
            <span className="font-black text-slate-900 text-xs uppercase tracking-wider">Đấu Trường & Xếp Hạng</span>
          </div>
          <p className="text-[11px] text-slate-600 font-bold leading-relaxed">
            Tranh cúp cùng bạn bè toàn quốc, nhận huy hiệu vinh danh.
          </p>
        </div>

        <div className="bg-white/95 backdrop-blur-sm border-[2.5px] border-slate-900 rounded-2xl p-4 shadow-[5px_5px_0_#1f2937]">
          <div className="flex items-center gap-2.5 mb-1.5">
            <span className="text-xl">⭐</span>
            <span className="font-black text-slate-900 text-xs uppercase tracking-wider">12.000+ Học Viên</span>
          </div>
          <p className="text-[11px] text-slate-600 font-bold leading-relaxed">
            Cộng đồng học viên luyện nói tiếng Việt sôi động mỗi ngày.
          </p>
        </div>
      </div>

      {/* Top Navigation Bar */}
      <header className="w-full max-w-6xl mx-auto flex items-center justify-between z-20 mb-4 sm:mb-6">
        <Link
          to="/"
          className="flex items-center gap-2.5 px-4 py-2 bg-white border-[2.5px] border-slate-900 rounded-2xl shadow-[4px_4px_0_#1f2937] text-slate-900 hover:bg-sky-50 transition-all font-black text-xs uppercase tracking-wider active:translate-y-0.5 active:shadow-none"
        >
          <Home size={16} strokeWidth={2.5} />
          <span>Về Trang Chủ</span>
        </Link>

        <div className="flex items-center gap-2.5 sm:gap-3">
          {/* Clickable System Status Pill */}
          <button
            type="button"
            onClick={() => setShowRecruiterModal(true)}
            className="hidden sm:flex items-center gap-2 px-3.5 py-1.5 bg-white hover:bg-emerald-50 border-[2px] border-slate-900 rounded-full shadow-[2px_2px_0_#1f2937] transition-all cursor-pointer active:translate-y-0.5"
            title="Bấm để xem chi tiết trạng thái máy chủ"
          >
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
            <span className="text-[11px] font-black text-slate-800">Hệ thống hoạt động bình thường</span>
          </button>

          {/* Dedicated Recruiter Note Button */}
          <button
            type="button"
            onClick={() => setShowRecruiterModal(true)}
            className="flex items-center gap-1.5 px-3.5 py-2 bg-amber-200 hover:bg-amber-300 border-[2.5px] border-slate-900 rounded-2xl shadow-[3px_3px_0_#1f2937] text-slate-900 font-black text-xs uppercase tracking-wider transition-all active:translate-y-0.5 active:shadow-none"
          >
            <Sparkles size={14} className="text-amber-700" />
            <span>⚡ Lưu Ý Nhà Tuyển Dụng</span>
          </button>

          <Link
            to="/register"
            className="flex items-center gap-1.5 px-4 py-2 bg-sky-300 border-[2.5px] border-slate-900 rounded-2xl shadow-[3px_3px_0_#1f2937] text-slate-900 hover:bg-sky-400 transition-all font-black text-xs uppercase tracking-wider active:translate-y-0.5 active:shadow-none"
          >
            <span>Đăng Ký</span>
            <ArrowRight size={14} strokeWidth={3} />
          </Link>
        </div>
      </header>

      {/* Main Login Card */}
      <main className="w-full flex items-center justify-center my-auto z-10 py-2">
        <motion.div
          initial={{ opacity: 0, y: 15 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.3 }}
          className="w-full max-w-5xl bg-white rounded-[2.5rem] border-[3.5px] border-slate-900 shadow-[12px_12px_0_#1f2937] flex flex-col lg:flex-row overflow-hidden relative"
        >
          {/* ==================== LEFT SIDE - VISUAL SHOWCASE ==================== */}
          <div className="w-full lg:w-5/12 bg-slate-900 border-b-[3.5px] lg:border-b-0 lg:border-r-[3.5px] border-slate-900 relative p-6 sm:p-8 flex flex-col justify-between overflow-hidden min-h-[320px] lg:min-h-[580px]">
            {/* Background image & gradient overlay */}
            <img
              src="/speakvn_simple_poster.png"
              alt="SpeakVN Poster"
              className="absolute inset-0 w-full h-full object-cover opacity-60 mix-blend-luminosity scale-105 hover:scale-110 transition-transform duration-1000"
            />
            <div className="absolute inset-0 bg-gradient-to-br from-[#0f172a]/90 via-[#0369a1]/85 to-[#0e7490]/90" />

            {/* Top Badge */}
            <div className="relative z-10 flex items-center justify-between">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 bg-white/10 backdrop-blur-md rounded-xl border border-white/20 text-white font-black text-[11px] tracking-wider uppercase">
                <Sparkles size={14} className="text-amber-300" />
                SpeakVN Luyện Ngữ Âm
              </div>
              <span className="text-xl">🇻🇳</span>
            </div>

            {/* Middle Content */}
            <div className="relative z-10 my-6 sm:my-8 text-white space-y-4">
              <h2 className="text-2xl sm:text-3xl font-black uppercase tracking-tight font-nunito leading-tight">
                Học Tiếng Việt<br />
                <span className="text-amber-300 drop-shadow-sm">Thật Vui Nhộn &amp;</span><br />
                Chuẩn Âm 3 Miền
              </h2>
              <p className="text-white/85 text-xs sm:text-sm font-semibold leading-relaxed max-w-md">
                Chinh phục ngữ điệu và phát âm chuẩn từng vùng miền với trợ lý AI phân tích giọng nói thông minh.
              </p>

              {/* Feature Chips */}
              <div className="space-y-2 pt-2">
                <div className="flex items-center gap-2.5 text-xs font-bold text-white/90 bg-white/10 backdrop-blur-sm px-3 py-2 rounded-xl border border-white/10">
                  <span className="text-base">🎙️</span>
                  <span>Nhận diện và sửa ngọng từng phụ âm n/l, tr/ch, d/gi/r</span>
                </div>
                <div className="flex items-center gap-2.5 text-xs font-bold text-white/90 bg-white/10 backdrop-blur-sm px-3 py-2 rounded-xl border border-white/10">
                  <span className="text-base">🗺️</span>
                  <span>Hành trình học tập phân nhánh Miền Bắc, Miền Trung, Miền Nam</span>
                </div>
                <div className="flex items-center gap-2.5 text-xs font-bold text-white/90 bg-white/10 backdrop-blur-sm px-3 py-2 rounded-xl border border-white/10">
                  <span className="text-base">🎮</span>
                  <span>Mini-game câu đố ngữ nghĩa &amp; đấu trường đua sao</span>
                </div>
              </div>
            </div>

            {/* Bottom Social Proof */}
            <div className="relative z-10 pt-4 border-t border-white/15 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="flex -space-x-2">
                  <img src="https://api.dicebear.com/7.x/adventurer/svg?seed=MinhAnh" alt="User 1" className="w-7 h-7 rounded-full border-2 border-slate-900 bg-sky-200" />
                  <img src="https://api.dicebear.com/7.x/adventurer/svg?seed=BaoLong" alt="User 2" className="w-7 h-7 rounded-full border-2 border-slate-900 bg-emerald-200" />
                  <img src="https://api.dicebear.com/7.x/adventurer/svg?seed=ThanhTruc" alt="User 3" className="w-7 h-7 rounded-full border-2 border-slate-900 bg-amber-200" />
                </div>
                <span className="text-[11px] font-bold text-white/90">12.000+ học viên tin dùng</span>
              </div>
              <span className="text-amber-300 font-black text-xs">⭐ 4.9/5</span>
            </div>
          </div>

          {/* ==================== RIGHT SIDE - LOGIN FORM ==================== */}
          <div className="w-full lg:w-7/12 p-6 sm:p-8 lg:p-10 bg-white flex flex-col justify-center">

            {/* Header Greeting */}
            <div className="mb-5">
              <div className="flex items-center gap-2 mb-1">
                <div className="w-8 h-8 rounded-xl bg-[#49B6E5] border-[2px] border-slate-900 shadow-[2px_2px_0_#1f2937] flex items-center justify-center">
                  <User size={16} className="text-white" strokeWidth={3} />
                </div>
                <span className="text-xs font-black uppercase tracking-wider text-[#0284c7]">Chào mừng bạn trở lại!</span>
              </div>
              <h1 className="text-2xl sm:text-3xl font-black text-slate-900 uppercase tracking-tight font-nunito">
                Đăng Nhập Tài Khoản
              </h1>
              <p className="text-slate-500 text-xs font-bold mt-1">
                Nhập thông tin bên dưới hoặc nhấn vào một trong 3 vai trò mẫu để trải nghiệm nhanh.
              </p>
            </div>

            {/* Quick Login Role Selector */}
            <div className="mb-5 p-3.5 bg-amber-50/90 border-[2.5px] border-slate-900 rounded-2xl shadow-[4px_4px_0_#1f2937]">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-1 mb-2.5">
                <span className="text-[11px] font-black uppercase tracking-wider text-slate-900 flex items-center gap-1.5">
                  <Zap size={14} className="text-amber-500 fill-amber-500" />
                  Đăng nhập nhanh 2 tài khoản test:
                </span>
                <span className="text-[9.5px] font-black text-slate-700 bg-white px-2.5 py-0.5 rounded-lg border border-slate-300 shadow-[1px_1px_0_#cbd5e1] self-start sm:self-auto">
                  Mật khẩu: <span className="text-sky-600 font-black">User@123</span>
                </span>
              </div>

              {/* Only 2 student accounts displayed (Admin & Educator hidden for security) */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                <button
                  type="button"
                  onClick={() => handleQuickSelect('student@fsa.com', 'Học viên 1')}
                  className={`p-3 rounded-2xl border-[2px] border-slate-900 text-left transition-all relative flex flex-col justify-between active:translate-y-0.5 ${
                    selectedRole === 'Học viên 1'
                      ? 'bg-sky-400 text-white shadow-[3px_3px_0_#1f2937] font-black'
                      : 'bg-white hover:bg-sky-50 text-slate-800 shadow-[2px_2px_0_#1f2937] font-bold'
                  }`}
                >
                  <div className="flex items-center justify-between w-full">
                    <div className="flex items-center gap-1.5">
                      <span className="text-base">🎒</span>
                      <span className="text-xs font-black uppercase tracking-tight">Học viên 1</span>
                    </div>
                    <span className={`text-[8.5px] font-black px-1.5 py-0.5 rounded-md border ${
                      selectedRole === 'Học viên 1' ? 'bg-white/20 border-white text-white' : 'bg-emerald-100 border-emerald-300 text-emerald-800'
                    }`}>
                      Full 100% Màn &amp; Sao
                    </span>
                  </div>
                  <div className="mt-2 pt-1 border-t border-slate-200/60">
                    <div className={`text-[10px] font-extrabold ${selectedRole === 'Học viên 1' ? 'text-white' : 'text-slate-800'}`}>student@fsa.com</div>
                    <div className={`text-[9px] mt-0.5 ${selectedRole === 'Học viên 1' ? 'text-white/85' : 'text-slate-500'}`}>
                      Đã mở khóa toàn bộ màn &amp; huy hiệu để review nhanh.
                    </div>
                  </div>
                </button>

                <button
                  type="button"
                  onClick={() => handleQuickSelect('tested_student@fsa.com', 'Học viên 2')}
                  className={`p-3 rounded-2xl border-[2px] border-slate-900 text-left transition-all relative flex flex-col justify-between active:translate-y-0.5 ${
                    selectedRole === 'Học viên 2'
                      ? 'bg-amber-400 text-slate-900 shadow-[3px_3px_0_#1f2937] font-black'
                      : 'bg-white hover:bg-amber-50 text-slate-800 shadow-[2px_2px_0_#1f2937] font-bold'
                  }`}
                >
                  <div className="flex items-center justify-between w-full">
                    <div className="flex items-center gap-1.5">
                      <span className="text-base">✨</span>
                      <span className="text-xs font-black uppercase tracking-tight">Học viên 2</span>
                    </div>
                    <span className={`text-[8.5px] font-black px-1.5 py-0.5 rounded-md border ${
                      selectedRole === 'Học viên 2' ? 'bg-white/20 border-slate-900 text-slate-900' : 'bg-amber-100 border-amber-300 text-amber-800'
                    }`}>
                      Tài Khoản Mới Tinh
                    </span>
                  </div>
                  <div className="mt-2 pt-1 border-t border-slate-200/60">
                    <div className={`text-[10px] font-extrabold ${selectedRole === 'Học viên 2' ? 'text-slate-900' : 'text-slate-800'}`}>tested_student@fsa.com</div>
                    <div className={`text-[9px] mt-0.5 ${selectedRole === 'Học viên 2' ? 'text-slate-900/85' : 'text-slate-500'}`}>
                      Lộ trình trống để trải nghiệm từ đầu (Entry Test).
                    </div>
                  </div>
                </button>
              </div>

              {/* Clickable Note for Recruiters */}
              <button
                type="button"
                onClick={() => setShowRecruiterModal(true)}
                className="w-full mt-2.5 py-1.5 px-2 bg-white/80 hover:bg-white border border-slate-300 rounded-xl text-[10px] font-black text-slate-700 hover:text-slate-900 flex items-center justify-center gap-1 transition-all"
              >
                <Sparkles size={11} className="text-amber-500" />
                <span>Bấm vào đây để xem Lưu Ý Nhà Tuyển Dụng (Cold-start &amp; AI 3 tầng)</span>
              </button>
            </div>

            {/* Form */}
            <Form
              form={form}
              name="login"
              layout="vertical"
              initialValues={{ remember: true }}
              onFinish={onFinish}
              autoComplete="off"
              size="large"
              className="doodle-form"
            >
              <Form.Item
                name="email"
                rules={[
                  { required: true, message: 'Vui lòng nhập email!' },
                  { type: 'email', message: 'Vui lòng nhập email hợp lệ!' }
                ]}
                className="mb-3.5"
              >
                <Input
                  prefix={<Mail size={18} className="text-slate-400 mr-2" strokeWidth={2.5} />}
                  placeholder="Địa chỉ Email (ví dụ: student@fsa.com)"
                  className="h-12 rounded-2xl border-[2.5px] border-slate-900 bg-slate-50 font-black text-xs shadow-[3px_3px_0_#1f2937] focus:bg-white transition-all"
                />
              </Form.Item>

              <Form.Item
                name="password"
                rules={passwordRules}
                className="mb-3"
              >
                <Input.Password
                  prefix={<Lock size={18} className="text-slate-400 mr-2" strokeWidth={2.5} />}
                  placeholder="Mật khẩu"
                  className="h-12 rounded-2xl border-[2.5px] border-slate-900 bg-slate-50 font-black text-xs shadow-[3px_3px_0_#1f2937] focus:bg-white transition-all"
                />
              </Form.Item>

              <div className="flex justify-between items-center mb-4">
                <Form.Item name="remember" valuePropName="checked" noStyle>
                  <Checkbox className="text-slate-900 text-xs font-black doodle-checkbox">
                    Ghi nhớ đăng nhập
                  </Checkbox>
                </Form.Item>
                <Link
                  to="/forgot-password"
                  className="text-orange-500 hover:text-orange-600 font-black text-xs transition-colors hover:underline"
                >
                  Quên mật khẩu?
                </Link>
              </div>

              <Form.Item className="mb-4">
                <Button
                  type="primary"
                  htmlType="submit"
                  block
                  className="h-12 rounded-2xl bg-[#49B6E5] hover:bg-[#38a5d4] text-white border-[2.5px] border-slate-900 shadow-[4px_4px_0_#1f2937] font-black text-sm uppercase tracking-wider flex items-center justify-center gap-2 transition-all hover:-translate-y-0.5 active:translate-y-0.5 active:shadow-none"
                >
                  <span>Đăng Nhập Ngay</span>
                  <ArrowRight size={18} strokeWidth={3} />
                </Button>
              </Form.Item>

              {/* Divider */}
              <div className="relative my-4">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t-[2px] border-slate-200" />
                </div>
                <div className="relative flex justify-center text-[10px] uppercase tracking-widest px-2">
                  <span className="bg-white px-3 text-slate-400 font-black">HOẶC TIẾP TỤC VỚI</span>
                </div>
              </div>

              {/* Social Login Buttons */}
              <div className="grid grid-cols-2 gap-3 mb-4">
                <button
                  type="button"
                  onClick={handleGoogleLogin}
                  disabled={googleLoading}
                  className="flex items-center justify-center gap-2 h-11 rounded-2xl border-[2px] border-slate-900 bg-white shadow-[3px_3px_0_#1f2937] hover:bg-slate-50 transition-all active:translate-y-0.5 active:shadow-none disabled:opacity-50"
                >
                  {googleLoading ? <DoodleLoading size="small" /> : (
                    <>
                      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24">
                        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
                        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                      </svg>
                      <span className="text-xs font-black uppercase tracking-wider text-slate-900">Google</span>
                    </>
                  )}
                </button>

                <button
                  type="button"
                  onClick={handleFacebookLogin}
                  disabled={facebookLoading}
                  className="flex items-center justify-center gap-2 h-11 rounded-2xl border-[2px] border-slate-900 bg-white shadow-[3px_3px_0_#1f2937] hover:bg-slate-50 transition-all active:translate-y-0.5 active:shadow-none disabled:opacity-50"
                >
                  {facebookLoading ? <DoodleLoading size="small" /> : (
                    <>
                      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="#1877F2">
                        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                      </svg>
                      <span className="text-xs font-black uppercase tracking-wider text-slate-900">Facebook</span>
                    </>
                  )}
                </button>
              </div>

              {/* Bottom Register Prompt */}
              <div className="text-center pt-2">
                <span className="text-slate-500 text-xs font-bold mr-1.5">Chưa có tài khoản?</span>
                <Link
                  to="/register"
                  className="text-[#0284c7] hover:text-[#0369a1] font-black text-xs uppercase tracking-wider hover:underline"
                >
                  Đăng Ký Ngay →
                </Link>
              </div>
            </Form>

            {/* Custom Scoped CSS */}
            <style>{`
              .doodle-form .ant-input-affix-wrapper {
                border: 2.5px solid #1f2937 !important;
                border-radius: 1rem !important;
                padding: 0 14px !important;
                box-shadow: 3px 3px 0 #1f2937 !important;
                transition: all 0.2s ease !important;
                background-color: #f8fafc !important;
              }
              .doodle-form .ant-input-affix-wrapper:hover {
                box-shadow: 4px 4px 0 #1f2937 !important;
                transform: translate(-1px, -1px);
              }
              .doodle-form .ant-input-affix-wrapper-focused {
                box-shadow: 4px 4px 0 #1f2937 !important;
                border-color: #49B6E5 !important;
                background-color: white !important;
              }
              .doodle-form .ant-form-item-explain-error {
                font-size: 10px;
                text-transform: uppercase;
                font-weight: 900;
                margin-top: 4px;
                color: #ef4444;
              }
              .doodle-checkbox .ant-checkbox-inner {
                border: 2px solid #1f2937 !important;
                border-radius: 6px !important;
                width: 18px !important;
                height: 18px !important;
              }
              .doodle-checkbox .ant-checkbox-checked .ant-checkbox-inner {
                background-color: #49B6E5 !important;
                border-color: #1f2937 !important;
              }
            `}</style>
          </div>
        </motion.div>
      </main>

      {/* Footer Info */}
      <footer className="w-full max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between text-slate-500 font-bold text-[11px] z-20 mt-4 pt-4 border-t border-slate-300/60">
        <div>© 2026 SpeakVN. Nền tảng luyện phát âm tiếng Việt đa vùng miền.</div>
        <div className="flex items-center gap-4 mt-2 sm:mt-0">
          <span>Bảo mật</span>
          <span>•</span>
          <span>Điều khoản</span>
          <span>•</span>
          <span>Hỗ trợ: support@speakvn.edu.vn</span>
        </div>
      </footer>

      {/* Recruiter Notice Modal */}
      <RecruiterNoticeModal
        isOpen={showRecruiterModal}
        onClose={() => setShowRecruiterModal(false)}
        onQuickLogin={handleModalQuickLogin}
      />
    </div>
  )
}

export default function Login() {
  return (
    <GoogleOAuthProvider clientId={GOOGLE_CLIENT_ID}>
      <LoginForm />
    </GoogleOAuthProvider>
  )
}
