-- ====================================================================
-- SEED SAMPLE DATA FOR SPEAKVN DATABASE (speakvn_db)
-- All accounts password: Pen1112003@ (BCrypt: $2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG)
-- ONLY SYSTEM ACCOUNTS:
-- 1. admin@fsa.com (ADMIN)
-- 2. educator@fsa.com (EDUCATOR)
-- 3. tested_student@fsa.com (USER - Học Viên Giọng Bắc Đã Test)
-- 4. student@fsa.com (USER - Học Viên Giọng Nam)
-- ====================================================================

-- 1. SYSTEM ACCOUNTS SETUP
-- Admin: admin@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000009',
    'admin@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'ADMIN',
    'Admin Hệ Thống',
    TRUE, TRUE, 'NORTH', TRUE, 100, 1000, 5, 10, 3, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'ADMIN',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    full_name = EXCLUDED.full_name;

-- Educator: educator@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000001',
    'educator@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'EDUCATOR',
    'Giáo Viên FSA',
    TRUE, TRUE, 'NORTH', TRUE, 150, 1500, 10, 15, 4, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'EDUCATOR',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    full_name = EXCLUDED.full_name;

-- Learner 1 (Đã Test, Giọng Bắc): tested_student@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000003',
    'tested_student@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'USER',
    'Học Viên FSA (Đã Test)',
    TRUE, TRUE, 'NORTH', TRUE, 220, 1850, 7, 14, 5, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'USER',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    has_done_entry_test = TRUE,
    total_stars = 220,
    total_experience = 1850,
    current_streak_days = 7,
    full_name = EXCLUDED.full_name;

-- Learner 2 (Giọng Nam): student@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000002',
    'student@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'USER',
    'Học Viên FSA',
    TRUE, TRUE, 'SOUTH', TRUE, 150, 950, 3, 5, 2, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'USER',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'SOUTH',
    has_done_entry_test = TRUE,
    total_stars = 150,
    total_experience = 950,
    current_streak_days = 3,
    full_name = EXCLUDED.full_name;

-- 2. MINIGAME CHALLENGES (WORD_CHALLENGE & SENTENCE_COMPLETION)
INSERT INTO minigame_challenge (id, game_type, pair_type, question_data, created_at, updated_at) VALUES
('00000000-0000-0005-0001-000000000001', 'WORD_CHALLENGE', 'N_L', '{"prompt": "Chọn từ đúng chỉ vật đội đầu che nắng che mưa:", "options": ["nón lá", "lón lá", "nón ná", "lón ná"], "correctIndex": 0, "explanation": "Từ đúng là ''nón lá'' (âm n).", "type": "CHOICE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000002', 'WORD_CHALLENGE', 'N_L', '{"prompt": "Sắp xếp các chữ cái để tạo từ chỉ mùa gặt lúa:", "targetWord": "lúa nếp", "scrambledLetters": ["l", "ú", "a", " ", "n", "ế", "p"], "explanation": "''Lúa nếp'' gồm lúa (âm l) và nếp (âm n).", "type": "SCRAMBLE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000003', 'WORD_CHALLENGE', 'S_X', '{"prompt": "Chọn từ đúng chỉ màu sắc của lá cây non:", "options": ["xanh xao", "sanh sao", "xanh sao", "sanh xao"], "correctIndex": 0, "explanation": "Từ đúng là ''xanh xao'' (âm x).", "type": "CHOICE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000004', 'WORD_CHALLENGE', 'S_X', '{"prompt": "Sắp xếp chữ cái tạo từ chỉ sự sung túc, no đủ:", "targetWord": "sung sướng", "scrambledLetters": ["s", "u", "n", "g", " ", "s", "ư", "ớ", "n", "g"], "explanation": "''Sung sướng'' cả hai từ đều bắt đầu bằng âm s.", "type": "SCRAMBLE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000005', 'WORD_CHALLENGE', 'TR_CH', '{"prompt": "Chọn từ đúng chỉ bầu trời không có mây:", "options": ["trời trong", "chời chong", "trời chong", "chời trong"], "correctIndex": 0, "explanation": "Từ đúng là ''trời trong'' (cả hai âm tr).", "type": "CHOICE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000006', 'WORD_CHALLENGE', 'TR_CH', '{"prompt": "Sắp xếp chữ cái tạo từ chỉ việc kiểm tra đúng sai:", "targetWord": "chính xác", "scrambledLetters": ["c", "h", "í", "n", "h", " ", "x", "á", "c"], "explanation": "''Chính xác'' từ đầu là âm ch.", "type": "SCRAMBLE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000007', 'WORD_CHALLENGE', 'D_GI_R', '{"prompt": "Chọn từ đúng chỉ người bảo ban, dạy dỗ:", "options": ["dạy dỗ", "giạy giỗ", "rạy rỗ", "dạy giỗ"], "correctIndex": 0, "explanation": "''Dạy dỗ'' viết bằng âm d.", "type": "CHOICE"}', NOW(), NOW()),
('00000000-0000-0005-0001-000000000008', 'WORD_CHALLENGE', 'D_GI_R', '{"prompt": "Sắp xếp chữ cái tạo từ chỉ cơn gió thổi mạnh:", "targetWord": "gió rét", "scrambledLetters": ["g", "i", "ó", " ", "r", "é", "t"], "explanation": "''Gió'' bắt đầu bằng gi, ''rét'' bắt đầu bằng r.", "type": "SCRAMBLE"}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000001', 'SENTENCE_COMPLETION', 'N_L', '{"sentence": "Bác nông dân đang cấy ___ trên cánh đồng bao la.", "options": ["lúa", "núa", "lúi", "núi"], "correctIndex": 0, "context": "Nông nghiệp, trồng trọt", "explanation": "Đáp án đúng là ''lúa'' (cây lương thực phổ biến ở Việt Nam)."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000002', 'SENTENCE_COMPLETION', 'N_L', '{"sentence": "Dòng sông quê hương đưa ___ về tưới mát ruộng đồng.", "options": ["nước", "lước", "nắng", "lắng"], "correctIndex": 0, "context": "Thiên nhiên dòng sông", "explanation": "Đáp án đúng là ''nước'' (chất lỏng tự nhiên)."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000003', 'SENTENCE_COMPLETION', 'S_X', '{"sentence": "Mùa xuân về, trăm hoa đua ___ nở rộ khắp bản làng.", "options": ["sắc", "xắc", "sức", "xức"], "correctIndex": 0, "context": "Cảnh sắc mùa xuân", "explanation": "''Đua sắc'' mang ý nghĩa khoe sắc hoa rực rỡ."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000004', 'SENTENCE_COMPLETION', 'S_X', '{"sentence": "Bé chăm chỉ tập thể dục để nâng cao ___ khỏe.", "options": ["sức", "xức", "sắc", "xắc"], "correctIndex": 0, "context": "Sức khỏe thể chất", "explanation": "''Sức khỏe'' viết bằng âm s."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000005', 'SENTENCE_COMPLETION', 'TR_CH', '{"sentence": "Bầu ___ hôm nay cao vút và trong xanh không một gợn mây.", "options": ["trời", "chời", "trăng", "chăng"], "correctIndex": 0, "context": "Thời tiết, bầu trời", "explanation": "''Bầu trời'' bắt đầu bằng âm tr."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000006', 'SENTENCE_COMPLETION', 'TR_CH', '{"sentence": "Học sinh nghe thầy cô giáo giảng bài rất ___ chú.", "options": ["chăm", "trăm", "chăn", "trăn"], "correctIndex": 0, "context": "Học tập trong lớp", "explanation": "''Chăm chú'' bắt đầu bằng âm ch."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000007', 'SENTENCE_COMPLETION', 'D_GI_R', '{"sentence": "Dưới bóng cây xanh râm mát, đàn trâu nằm ___ nghỉ.", "options": ["nghỉ ngơi", "râm ran", "dịu dàng", "rộn rã"], "correctIndex": 0, "context": "Nghỉ ngơi buổi trưa", "explanation": "Cụm từ hoàn chỉnh là ''nghỉ ngơi''."}', NOW(), NOW()),
('00000000-0000-0005-0002-000000000008', 'SENTENCE_COMPLETION', 'D_GI_R', '{"sentence": "Dòng sông Hồng đỏ nặng phù sa trôi ___ xuôi về biển cả.", "options": ["dạt dào", "giạt giào", "rạt rào", "dạt rào"], "correctIndex": 0, "context": "Dòng sông dòng nước", "explanation": "''Dạt dào'' bắt đầu bằng âm d."}', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    question_data = EXCLUDED.question_data,
    updated_at = NOW();

-- 3. CHAT MESSAGES
INSERT INTO chat_message (id, sender_id, recipient_id, content, "timestamp", status, created_at, updated_at) VALUES
('00000000-0000-0006-0002-000000000001', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'Chào bạn, hôm nay bạn đã luyện phát âm âm n/l chưa?', NOW() - INTERVAL '4 hours', 'READ', NOW() - INTERVAL '4 hours', NOW()),
('00000000-0000-0006-0002-000000000002', '00000000-0000-0000-0002-000000000003', '00000000-0000-0000-0002-000000000002', 'Mình vừa hoàn thành xong 3 thử thách hàng ngày rồi, được 95% điểm nè!', NOW() - INTERVAL '3 hours', 'READ', NOW() - INTERVAL '3 hours', NOW()),
('00000000-0000-0006-0002-000000000003', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'Tuyệt vời quá! Tuần này cố gắng giữ vị trí top bảng xếp hạng giải đấu nhé!', NOW() - INTERVAL '1 hour', 'SENT', NOW() - INTERVAL '1 hour', NOW())
ON CONFLICT (id) DO UPDATE SET
    content = EXCLUDED.content,
    sender_id = EXCLUDED.sender_id,
    recipient_id = EXCLUDED.recipient_id;

-- 4. USER FEEDBACK FOR ADMIN
INSERT INTO user_feedback (
    id, sender_id, category, title, content, status, admin_note, created_at, updated_at
) VALUES 
(
    '00000000-0000-0010-0001-000000000001',
    '00000000-0000-0000-0002-000000000003',
    'BUG',
    'Micro tự ngắt khi kết nối mạng yếu',
    'Khi kết nối mạng chập chờn, micro đôi khi tự tắt giữa chừng khi em đang đọc câu dài.',
    'IN_PROGRESS',
    'Đang kiểm tra cơ chế retry và buffer của audio recorder trên trình duyệt mobile.',
    NOW() - INTERVAL '2 days',
    NOW()
),
(
    '00000000-0000-0010-0001-000000000002',
    '00000000-0000-0000-0002-000000000003',
    'UI',
    'Khen ngợi giao diện doodle dễ thương',
    'Giao diện mới rất sáng sủa, hoạt ảnh động vật doodle dễ thương giúp giảm bớt căng thẳng khi luyện nói.',
    'RESOLVED',
    'Cảm ơn bạn đã phản hồi! Đội ngũ sẽ tiếp tục tối ưu hóa đồ họa.',
    NOW() - INTERVAL '3 days',
    NOW()
),
(
    '00000000-0000-0010-0001-000000000003',
    '00000000-0000-0000-0002-000000000003',
    'FEATURE',
    'Đề xuất tính năng thi đấu trực tiếp 1v1',
    'Đề xuất thêm chế độ thi đấu đối kháng trực tiếp 1v1 theo thời gian thực giữa hai người bạn.',
    'PENDING',
    NULL,
    NOW() - INTERVAL '1 day',
    NOW()
),
(
    '00000000-0000-0010-0001-000000000004',
    '00000000-0000-0000-0002-000000000002',
    'CONTENT',
    'Hỏi thêm bài nghe giọng miền Trung',
    'Phần cẩm nang phát âm giọng miền Trung rất hữu ích, mong có thêm các bài nghe phân biệt hỏi ngã.',
    'RESOLVED',
    'Đã thêm vào lộ trình cập nhật học liệu quý 2.',
    NOW() - INTERVAL '4 days',
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- 5. CUSTOM LEARNING PATHS, LEVELS & PROGRESS
INSERT INTO custom_learning_paths (
    id, student_id, educator_id, title, description, is_active, is_ai_generated, ai_feedback, target_level, created_at, updated_at
) VALUES (
    '00000000-0000-0007-0001-000000000001',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0000-0002-000000000001',
    'Lộ Trình Sửa Ngọng Chuyên Sâu Âm N/L & TR/CH',
    'Lộ trình tùy biến được thiết kế riêng nhằm khắc phục triệt để nhầm lẫn giữa âm N/L và TR/CH.',
    TRUE,
    TRUE,
    'Cần tập trung phát âm tròn vành rõ chữ, phân biệt vị trí đặt lưỡi giữa n (đầu lưỡi chạm nướu trên) và l (uốn lưỡi).',
    'INTERMEDIATE',
    NOW() - INTERVAL '5 days',
    NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO custom_path_levels (id, custom_path_id, level_id, order_index) VALUES
('00000000-0000-0007-0002-000000000001', '00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0073-110000000000', 1),
('00000000-0000-0007-0002-000000000002', '00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0073-120000000000', 2),
('00000000-0000-0007-0002-000000000003', '00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0073-130000000000', 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO custom_path_progress (id, custom_path_id, learning_unit_id, score, is_completed, created_at, updated_at) VALUES
('00000000-0000-0007-0003-000000000001', '00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0073-110000000000', 92, TRUE, NOW() - INTERVAL '2 days', NOW()),
('00000000-0000-0007-0003-000000000002', '00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0073-120000000000', 78, FALSE, NOW() - INTERVAL '1 day', NOW())
ON CONFLICT (id) DO NOTHING;

-- 6. CONTENT ITEMS (FOR SESSIONS & DETAILS)
INSERT INTO content_item (id, learning_unit_id, title, type, status, created_at, updated_at) VALUES
('00000000-0000-0008-0000-000000000001', '00000000-0000-0000-0073-110000000000', 'Luyện tập phát âm từ nón lá', 'PRONUNCIATION', 'APPROVED', NOW() - INTERVAL '3 days', NOW()),
('00000000-0000-0008-0000-000000000002', '00000000-0000-0000-0073-120000000000', 'Luyện tập phân biệt lúa nếp', 'PRONUNCIATION', 'APPROVED', NOW() - INTERVAL '3 days', NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO study_session (id, account_id, session_type, started_at, ended_at, created_at, updated_at) VALUES
('00000000-0000-0008-0001-000000000001', '00000000-0000-0000-0002-000000000003', 'PRACTICE', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days' + INTERVAL '15 minutes', NOW() - INTERVAL '2 days', NOW()),
('00000000-0000-0008-0001-000000000002', '00000000-0000-0000-0002-000000000003', 'CHALLENGE', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '20 minutes', NOW() - INTERVAL '1 day', NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO session_detail (id, session_id, content_item_id, is_passed, score_overall, created_at, updated_at) VALUES
('00000000-0000-0008-0002-000000000001', '00000000-0000-0008-0001-000000000001', '00000000-0000-0008-0000-000000000001', TRUE, 92.50, NOW() - INTERVAL '2 days', NOW()),
('00000000-0000-0008-0002-000000000002', '00000000-0000-0008-0001-000000000002', '00000000-0000-0008-0000-000000000002', TRUE, 85.00, NOW() - INTERVAL '1 day', NOW())
ON CONFLICT (id) DO NOTHING;

-- 7. SPEAKING ATTEMPTS
INSERT INTO speaking_attempt (
    id, account_id, challenge_id, target_text, asr_transcription, audio_url,
    groq_score, asr_score, is_correct, dialect, consent_given, processing_time_ms, asr_processing_time_ms, groq_feedback, created_at, updated_at
) VALUES 
(
    '00000000-0000-0008-0003-000000000001',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0073-1101-000000000001',
    'nón lá',
    'nón lá',
    'https://res.cloudinary.com/demo/video/upload/sample_audio_1.mp3',
    95, 94, TRUE, 'NORTH', TRUE, 320, 180,
    'Phát âm tròn vành rõ chữ, âm n đầu câu rất chuẩn xác.',
    NOW() - INTERVAL '2 days', NOW()
),
(
    '00000000-0000-0008-0003-000000000002',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0073-1101-000000000002',
    'lúa nếp',
    'lúa nếp',
    'https://res.cloudinary.com/demo/video/upload/sample_audio_2.mp3',
    88, 87, TRUE, 'NORTH', TRUE, 280, 150,
    'Lưu ý khẩu hình mở rộng hơn khi phát âm âm l.',
    NOW() - INTERVAL '1 day', NOW()
) ON CONFLICT (id) DO NOTHING;

-- 8. EDUCATOR FEEDBACK
INSERT INTO educator_feedback (
    id, educator_id, student_id, speaking_attempt_id, comment, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0009-0001-000000000001',
    '00000000-0000-0000-0002-000000000001', -- Giáo viên FSA
    '00000000-0000-0000-0002-000000000003', -- Học viên FSA (Đã Test)
    '00000000-0000-0008-0003-000000000001',
    'Em phát âm câu này rất tự tin và tự nhiên. Phần âm n đã khắc phục tốt so với bài test đầu vào. Tiếp tục phát huy nhé!',
    'NORMAL',
    NOW() - INTERVAL '1 day',
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- 9. ACCOUNT REWARDS (UNLOCKED ACHIEVEMENTS)
INSERT INTO account_reward (id, account_id, reward_catalog_id, status, progress_value, unlocked_at, created_at, updated_at) VALUES
('00000000-0000-0011-0001-000000000001', '00000000-0000-0000-0002-000000000003', '922260b3-bb97-4ca8-bb21-65116ae33f1f', 'UNLOCKED', 1, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NOW()),
('00000000-0000-0011-0001-000000000002', '00000000-0000-0000-0002-000000000003', 'ca7489f9-287f-4fbf-805a-bbb91a1777e2', 'UNLOCKED', 1, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days', NOW()),
('00000000-0000-0011-0001-000000000003', '00000000-0000-0000-0002-000000000003', '847c61a7-1f0a-4176-8187-7fc56142cc38', 'UNLOCKED', 1, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW())
ON CONFLICT (id) DO NOTHING;

-- 10. DAILY CHALLENGE ATTEMPTS
INSERT INTO daily_challenge_attempt (
    id, account_id, challenge_id, is_correct, score, audio_url, feedback, dialect, created_at, updated_at
) VALUES 
(
    '00000000-0000-0013-0001-000000000001',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0073-1101-000000000001',
    TRUE, 95,
    'https://res.cloudinary.com/demo/video/upload/daily_1.mp3',
    'Phát âm chính xác',
    'NORTH',
    NOW() - INTERVAL '3 hours', NOW()
),
(
    '00000000-0000-0013-0001-000000000002',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0073-1101-000000000002',
    TRUE, 92,
    'https://res.cloudinary.com/demo/video/upload/daily_2.mp3',
    'Đạt yêu cầu',
    'NORTH',
    NOW() - INTERVAL '2 hours', NOW()
) ON CONFLICT (id) DO NOTHING;

-- 11. LESSON PLANS FOR EDUCATOR
INSERT INTO lesson_plans (
    id, educator_id, title, objective, target_students_json, achievement_goals_json, status, created_at, updated_at
) VALUES (
    '00000000-0000-0015-0001-000000000001',
    '00000000-0000-0000-0002-000000000001',
    'Giáo án Phân Biệt Âm Đầu N và L Miền Bắc',
    'Giúp học viên nhận diện nguyên nhân ngọng n/l và làm chủ khẩu hình uốn lưỡi qua 5 bài tập thực hành.',
    '["00000000-0000-0000-0002-000000000003", "00000000-0000-0000-0002-000000000002"]',
    '{"minAccuracy": 85, "requiredDays": 7, "targetPhonemes": ["n", "l"]}',
    'PUBLISHED',
    NOW() - INTERVAL '3 days',
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- 12. ACCOUNT LEARNING UNIT PROGRESS
INSERT INTO account_learning_unit (
    id, account_id, learning_unit_id, stars_earned, is_completed, highest_score, is_unlocked, created_at, updated_at
) VALUES 
(
    '00000000-0000-0016-0001-000000000001',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0000-0073-110000000000',
    3, TRUE, 96.00, TRUE, NOW() - INTERVAL '5 days', NOW()
),
(
    '00000000-0000-0016-0001-000000000002',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0000-0073-120000000000',
    2, TRUE, 88.00, TRUE, NOW() - INTERVAL '3 days', NOW()
),
(
    '00000000-0000-0016-0001-000000000003',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0000-0073-130000000000',
    0, FALSE, 0.00, TRUE, NOW() - INTERVAL '1 day', NOW()
) ON CONFLICT (id) DO NOTHING;

-- 13. NOTIFICATIONS
INSERT INTO notification (id, recipient_id, title, message, type, is_read, created_at) VALUES
('00000000-0000-0012-0001-000000000001', '00000000-0000-0000-0002-000000000003', 'Chào mừng đến với SpeakVN!', 'Hãy hoàn thành bài luyện tập hàng ngày để tích lũy sao và duy trì chuỗi học tập.', 'SYSTEM', FALSE, NOW() - INTERVAL '5 days'),
('00000000-0000-0012-0001-000000000002', '00000000-0000-0000-0002-000000000003', 'Nhắc nhở chuỗi học (Streak)', 'Bạn đã đạt chuỗi 7 ngày liên tiếp! Hãy giữ vững phong độ nhé.', 'REMINDER', FALSE, NOW() - INTERVAL '1 day'),
('00000000-0000-0012-0001-000000000003', '00000000-0000-0000-0002-000000000003', 'Giải đấu tuần đã mở', 'Giải Đấu Tuần SpeakVN hiện đang diễn ra. Tham gia ngay để giành thứ hạng cao nhất!', 'TOURNAMENT', FALSE, NOW() - INTERVAL '2 days'),
('00000000-0000-0012-0001-000000000004', '00000000-0000-0000-0002-000000000003', 'Đạt huy hiệu mới', 'Chúc mừng bạn đã mở khóa huy hiệu ''Chiến Binh Chăm Chỉ''!', 'ACHIEVEMENT', TRUE, NOW() - INTERVAL '3 days')
ON CONFLICT (id) DO NOTHING;

-- 14. ASSIGNMENT
INSERT INTO assignment (
    id, learning_unit_id, classroom_id, assigned_by, description, due_date, status, created_at
) VALUES (
    '00000000-0000-0014-0001-000000000001',
    '00000000-0000-0000-0073-110000000000',
    '00000000-0000-0000-0003-000000000001',
    '00000000-0000-0000-0002-000000000001',
    'Luyện phát âm các câu chào hỏi cơ bản giọng miền Bắc, nộp ghi âm trước chủ nhật.',
    NOW() + INTERVAL '3 days',
    'OPEN',
    NOW()
) ON CONFLICT (id) DO NOTHING;
