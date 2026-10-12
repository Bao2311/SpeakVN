-- ====================================================================
-- SEED SAMPLE DATA FOR SPEAKVN DATABASE (speakvn_db)
-- All accounts password: Pen1112003@ (BCrypt: $2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG)
-- Includes:
-- 1. System Accounts (Admin, Educator, Demo Student, Tested Student)
-- 2. 8 Realistic Friend Accounts with Avatars
-- 3. Friendships with Demo Account
-- 4. 50% Journey Progress Unlocked for Demo Accounts (Quizzes 1-7 completed with 3 stars, Quiz 8 unlocked)
-- 5. Leaderboard Entries (Global, South, North, Central)
-- 6. Tournaments for the Next Month (30 Days) & Participants
-- 7. Minigames, Chat, Feedback, Custom Paths, Speaking Attempts, Rewards, Notifications
-- ====================================================================

-- 1. SYSTEM ACCOUNTS SETUP
-- Admin: admin@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, avatar_url, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000009',
    'admin@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'ADMIN',
    'Quản trị viên',
    'https://api.dicebear.com/7.x/bottts/svg?seed=AdminFSA',
    TRUE, TRUE, 'NORTH', TRUE, 100, 1000, 5, 10, 3, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'ADMIN',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    avatar_url = EXCLUDED.avatar_url,
    full_name = EXCLUDED.full_name;

-- Educator: educator@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, avatar_url, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000001',
    'educator@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'EDUCATOR',
    'Giảng viên',
    'https://api.dicebear.com/7.x/bottts/svg?seed=EducatorFSA',
    TRUE, TRUE, 'NORTH', TRUE, 150, 1500, 10, 15, 4, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'EDUCATOR',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    avatar_url = EXCLUDED.avatar_url,
    full_name = EXCLUDED.full_name;

-- Demo Learner 1 (Giọng Nam): student@fsa.com
-- 21 stars exactly matching 7 completed quizzes (7 * 3 = 21)
INSERT INTO account (
    id, email, password_hash, role_code, full_name, avatar_url, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000002',
    'student@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'USER',
    'Học viên 1',
    'https://api.dicebear.com/7.x/adventurer/svg?seed=HocVienDemo',
    TRUE, TRUE, 'SOUTH', TRUE, 21, 450, 3, 5, 2, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'USER',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'SOUTH',
    has_done_entry_test = TRUE,
    total_stars = 21,
    total_experience = 450,
    current_streak_days = 3,
    avatar_url = EXCLUDED.avatar_url,
    full_name = EXCLUDED.full_name;

-- Demo Learner 2 (Giọng Bắc): tested_student@fsa.com
INSERT INTO account (
    id, email, password_hash, role_code, full_name, avatar_url, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0002-000000000003',
    'tested_student@fsa.com',
    '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG',
    'USER',
    'Học viên 2',
    'https://api.dicebear.com/7.x/adventurer/svg?seed=HocVienNorth',
    TRUE, TRUE, 'NORTH', TRUE, 21, 450, 5, 7, 3, NOW(), NOW()
) ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role_code = 'USER',
    email_verified = TRUE,
    is_active = TRUE,
    region = 'NORTH',
    has_done_entry_test = TRUE,
    total_stars = 21,
    total_experience = 450,
    current_streak_days = 5,
    avatar_url = EXCLUDED.avatar_url,
    full_name = EXCLUDED.full_name;

-- 2. 8 REALISTIC FRIEND ACCOUNTS WITH CUTE AVATARS
INSERT INTO account (
    id, email, password_hash, role_code, full_name, avatar_url, email_verified, is_active,
    region, has_done_entry_test, total_stars, total_experience, current_streak_days, max_streak_days, badge_count, created_at, updated_at
) VALUES
('00000000-0000-0000-0002-000000000010', 'minhanh@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Trần Minh Anh', 'https://api.dicebear.com/7.x/adventurer/svg?seed=MinhAnh', TRUE, TRUE, 'NORTH', TRUE, 45, 920, 12, 15, 6, NOW() - INTERVAL '30 days', NOW()),
('00000000-0000-0000-0002-000000000011', 'baolong@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Lê Bảo Long', 'https://api.dicebear.com/7.x/adventurer/svg?seed=BaoLong', TRUE, TRUE, 'SOUTH', TRUE, 39, 810, 9, 14, 5, NOW() - INTERVAL '25 days', NOW()),
('00000000-0000-0000-0002-000000000012', 'thanhtruc@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Nguyễn Thanh Trúc', 'https://api.dicebear.com/7.x/adventurer/svg?seed=ThanhTruc', TRUE, TRUE, 'CENTRAL', TRUE, 33, 680, 8, 10, 4, NOW() - INTERVAL '20 days', NOW()),
('00000000-0000-0000-0002-000000000013', 'hoangnam@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Phạm Hoàng Nam', 'https://api.dicebear.com/7.x/adventurer/svg?seed=HoangNam', TRUE, TRUE, 'NORTH', TRUE, 27, 560, 6, 8, 3, NOW() - INTERVAL '18 days', NOW()),
('00000000-0000-0000-0002-000000000014', 'khanhvy@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Võ Khánh Vy', 'https://api.dicebear.com/7.x/adventurer/svg?seed=KhanhVy', TRUE, TRUE, 'SOUTH', TRUE, 21, 440, 4, 7, 3, NOW() - INTERVAL '15 days', NOW()),
('00000000-0000-0000-0002-000000000015', 'quocbao@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Đặng Quốc Bảo', 'https://api.dicebear.com/7.x/adventurer/svg?seed=QuocBao', TRUE, TRUE, 'CENTRAL', TRUE, 18, 380, 3, 5, 2, NOW() - INTERVAL '12 days', NOW()),
('00000000-0000-0000-0002-000000000016', 'duchuy@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Hoàng Đức Huy', 'https://api.dicebear.com/7.x/adventurer/svg?seed=DucHuy', TRUE, TRUE, 'NORTH', TRUE, 15, 310, 2, 4, 2, NOW() - INTERVAL '10 days', NOW()),
('00000000-0000-0000-0002-000000000017', 'maichi@fsa.com', '$2a$10$Wl82NGnlI1aRa77o2u0v..ua1Fbi9jfkL4DwEBFMRij9tZylRPuPG', 'USER', 'Bùi Mai Chi', 'https://api.dicebear.com/7.x/adventurer/svg?seed=MaiChi', TRUE, TRUE, 'SOUTH', TRUE, 12, 250, 1, 3, 1, NOW() - INTERVAL '7 days', NOW())
ON CONFLICT (email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    avatar_url = EXCLUDED.avatar_url,
    total_stars = EXCLUDED.total_stars,
    total_experience = EXCLUDED.total_experience,
    current_streak_days = EXCLUDED.current_streak_days,
    region = EXCLUDED.region;

-- 3. FRIENDSHIPS
DELETE FROM friendship WHERE requester_id IN ('00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003')
   OR addressee_id IN ('00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003');

INSERT INTO friendship (id, requester_id, addressee_id, status, created_at, updated_at) VALUES
-- student@fsa.com accepted friends
('00000000-0000-0007-0001-000000000001', '00000000-0000-0000-0002-000000000010', '00000000-0000-0000-0002-000000000002', 'ACCEPTED', NOW() - INTERVAL '10 days', NOW()),
('00000000-0000-0007-0001-000000000002', '00000000-0000-0000-0002-000000000011', '00000000-0000-0000-0002-000000000002', 'ACCEPTED', NOW() - INTERVAL '8 days', NOW()),
('00000000-0000-0007-0001-000000000003', '00000000-0000-0000-0002-000000000012', '00000000-0000-0000-0002-000000000002', 'ACCEPTED', NOW() - INTERVAL '6 days', NOW()),
('00000000-0000-0007-0001-000000000004', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000013', 'ACCEPTED', NOW() - INTERVAL '4 days', NOW()),
('00000000-0000-0007-0001-000000000005', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000014', 'ACCEPTED', NOW() - INTERVAL '2 days', NOW()),
-- friend request received
('00000000-0000-0007-0001-000000000006', '00000000-0000-0000-0002-000000000015', '00000000-0000-0000-0002-000000000002', 'PENDING', NOW() - INTERVAL '1 day', NOW()),
-- friend request sent
('00000000-0000-0007-0001-000000000007', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000016', 'PENDING', NOW() - INTERVAL '5 hours', NOW()),
-- Friendship between 2 demo students so they can chat with each other!
('00000000-0000-0007-0001-000000000099', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'ACCEPTED', NOW() - INTERVAL '15 days', NOW()),
-- tested_student friendships
('00000000-0000-0007-0001-000000000008', '00000000-0000-0000-0002-000000000010', '00000000-0000-0000-0002-000000000003', 'ACCEPTED', NOW() - INTERVAL '15 days', NOW()),
('00000000-0000-0007-0001-000000000009', '00000000-0000-0000-0002-000000000013', '00000000-0000-0000-0002-000000000003', 'ACCEPTED', NOW() - INTERVAL '7 days', NOW())
ON CONFLICT (id) DO NOTHING;

-- 4. UNLOCK ~50% JOURNEY FOR DEMO ACCOUNTS (QUIZZES 1-7 COMPLETED WITH 3 STARS)
DELETE FROM account_learning_unit 
WHERE account_id IN ('00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003');

-- For student@fsa.com (South) on Level 1 Nam (0073-310000000000):
INSERT INTO account_learning_unit (id, account_id, learning_unit_id, stars_earned, is_completed, highest_score, is_unlocked, created_at, updated_at) VALUES
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3101-000000000000', 3, TRUE, 96.00, TRUE, NOW() - INTERVAL '7 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3102-000000000000', 3, TRUE, 94.00, TRUE, NOW() - INTERVAL '6 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3103-000000000000', 3, TRUE, 92.00, TRUE, NOW() - INTERVAL '5 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3104-000000000000', 3, TRUE, 98.00, TRUE, NOW() - INTERVAL '4 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3105-000000000000', 3, TRUE, 90.00, TRUE, NOW() - INTERVAL '3 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3106-000000000000', 3, TRUE, 95.00, TRUE, NOW() - INTERVAL '2 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3107-000000000000', 3, TRUE, 91.00, TRUE, NOW() - INTERVAL '1 day', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-3108-000000000000', 0, FALSE, 0.00, TRUE, NOW(), NOW());

-- Also for student@fsa.com on Level 1 Bac (0073-110000000000):
INSERT INTO account_learning_unit (id, account_id, learning_unit_id, stars_earned, is_completed, highest_score, is_unlocked, created_at, updated_at) VALUES
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1101-000000000000', 3, TRUE, 95.00, TRUE, NOW() - INTERVAL '7 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1102-000000000000', 3, TRUE, 93.00, TRUE, NOW() - INTERVAL '6 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1103-000000000000', 3, TRUE, 97.00, TRUE, NOW() - INTERVAL '5 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1104-000000000000', 3, TRUE, 90.00, TRUE, NOW() - INTERVAL '4 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1105-000000000000', 3, TRUE, 94.00, TRUE, NOW() - INTERVAL '3 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1106-000000000000', 3, TRUE, 96.00, TRUE, NOW() - INTERVAL '2 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1107-000000000000', 3, TRUE, 92.00, TRUE, NOW() - INTERVAL '1 day', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000002', '00000000-0000-0073-1108-000000000000', 0, FALSE, 0.00, TRUE, NOW(), NOW());

-- Also for tested_student@fsa.com on Level 1 Bac:
INSERT INTO account_learning_unit (id, account_id, learning_unit_id, stars_earned, is_completed, highest_score, is_unlocked, created_at, updated_at) VALUES
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1101-000000000000', 3, TRUE, 97.00, TRUE, NOW() - INTERVAL '7 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1102-000000000000', 3, TRUE, 95.00, TRUE, NOW() - INTERVAL '6 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1103-000000000000', 3, TRUE, 98.00, TRUE, NOW() - INTERVAL '5 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1104-000000000000', 3, TRUE, 91.00, TRUE, NOW() - INTERVAL '4 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1105-000000000000', 3, TRUE, 93.00, TRUE, NOW() - INTERVAL '3 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1106-000000000000', 3, TRUE, 96.00, TRUE, NOW() - INTERVAL '2 days', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1107-000000000000', 3, TRUE, 94.00, TRUE, NOW() - INTERVAL '1 day', NOW()),
(gen_random_uuid(), '00000000-0000-0000-0002-000000000003', '00000000-0000-0073-1108-000000000000', 0, FALSE, 0.00, TRUE, NOW(), NOW());

-- 5. LEADERBOARD ENTRIES (GLOBAL, SOUTH, NORTH, CENTRAL)
DELETE FROM leaderboard_entry;

-- Global Leaderboard (bc089c39-e689-4df7-9d33-3b5c22ea8d04)
INSERT INTO leaderboard_entry (id, leaderboard_id, account_id, rank_position, total_xp, total_stars, challenges_completed, average_score, streak_days, badge_count) VALUES
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000010', 1, 920, 45, 15, 96.5, 12, 6),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000011', 2, 810, 39, 13, 94.0, 9, 5),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000012', 3, 680, 33, 11, 93.2, 8, 4),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000013', 4, 560, 27, 9, 91.0, 6, 3),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000002', 5, 450, 21, 7, 94.2, 3, 2), -- Demo Learner!
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000014', 6, 440, 21, 7, 90.5, 4, 3),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000015', 7, 380, 18, 6, 88.0, 3, 2),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000016', 8, 310, 15, 5, 87.5, 2, 2),
(gen_random_uuid(), 'bc089c39-e689-4df7-9d33-3b5c22ea8d04', '00000000-0000-0000-0002-000000000017', 9, 250, 12, 4, 85.0, 1, 1);

-- Regional South Leaderboard (084cfe14-ed9a-4138-8603-c2ce8116b9fe)
INSERT INTO leaderboard_entry (id, leaderboard_id, account_id, rank_position, total_xp, total_stars, challenges_completed, average_score, streak_days, badge_count) VALUES
(gen_random_uuid(), '084cfe14-ed9a-4138-8603-c2ce8116b9fe', '00000000-0000-0000-0002-000000000011', 1, 810, 39, 13, 94.0, 9, 5), -- Lê Bảo Long
(gen_random_uuid(), '084cfe14-ed9a-4138-8603-c2ce8116b9fe', '00000000-0000-0000-0002-000000000002', 2, 450, 21, 7, 94.2, 3, 2),  -- Demo Learner!
(gen_random_uuid(), '084cfe14-ed9a-4138-8603-c2ce8116b9fe', '00000000-0000-0000-0002-000000000014', 3, 440, 21, 7, 90.5, 4, 3), -- Võ Khánh Vy
(gen_random_uuid(), '084cfe14-ed9a-4138-8603-c2ce8116b9fe', '00000000-0000-0000-0002-000000000017', 4, 250, 12, 4, 85.0, 1, 1); -- Bùi Mai Chi

-- Regional North Leaderboard (413739b1-7d0b-49bc-b862-f704522e2019)
INSERT INTO leaderboard_entry (id, leaderboard_id, account_id, rank_position, total_xp, total_stars, challenges_completed, average_score, streak_days, badge_count) VALUES
(gen_random_uuid(), '413739b1-7d0b-49bc-b862-f704522e2019', '00000000-0000-0000-0002-000000000010', 1, 920, 45, 15, 96.5, 12, 6), -- Trần Minh Anh
(gen_random_uuid(), '413739b1-7d0b-49bc-b862-f704522e2019', '00000000-0000-0000-0002-000000000013', 2, 560, 27, 9, 91.0, 6, 3),  -- Phạm Hoàng Nam
(gen_random_uuid(), '413739b1-7d0b-49bc-b862-f704522e2019', '00000000-0000-0000-0002-000000000003', 3, 450, 21, 7, 94.0, 5, 3),  -- Học viên thử nghiệm
(gen_random_uuid(), '413739b1-7d0b-49bc-b862-f704522e2019', '00000000-0000-0000-0002-000000000016', 4, 310, 15, 5, 87.5, 2, 2);  -- Hoàng Đức Huy

-- Regional Central Leaderboard (8b7b7900-d570-4d68-9ed0-03cbfcb88ce9)
INSERT INTO leaderboard_entry (id, leaderboard_id, account_id, rank_position, total_xp, total_stars, challenges_completed, average_score, streak_days, badge_count) VALUES
(gen_random_uuid(), '8b7b7900-d570-4d68-9ed0-03cbfcb88ce9', '00000000-0000-0000-0002-000000000012', 1, 680, 33, 11, 93.2, 8, 4), -- Nguyễn Thanh Trúc
(gen_random_uuid(), '8b7b7900-d570-4d68-9ed0-03cbfcb88ce9', '00000000-0000-0000-0002-000000000015', 2, 380, 18, 6, 88.0, 3, 2);  -- Đặng Quốc Bảo

-- 6. TOURNAMENTS FOR THE NEXT MONTH (Covering next 30 days)
DELETE FROM tournament_participant;
DELETE FROM tournament;

INSERT INTO tournament (
    id, name, description, type, status, region_code, starts_at, ends_at, max_participants, banner_url, prize_config_json, created_at, updated_at
) VALUES
(
    '00000000-0000-0008-0001-000000000001',
    'Đấu Trường Phát Âm Miền Nam - Tuần 1',
    'Tranh tài phân biệt phụ âm đầu d/gi/r chuẩn giọng phương Nam. Dành cho các chiến binh luyện âm sôi nổi nhất!',
    'WEEKLY',
    'ACTIVE',
    'SOUTH',
    NOW() - INTERVAL '2 days',
    NOW() + INTERVAL '5 days',
    100,
    'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&q=80',
    '{"firstPrize": "500 XP + Huy Hiệu Quán Quân", "secondPrize": "300 XP", "thirdPrize": "150 XP"}',
    NOW() - INTERVAL '3 days', NOW()
),
(
    '00000000-0000-0008-0001-000000000002',
    'Thử Thách Luyện Âm Chuẩn Bắc - Mùa Xuân',
    'Chinh phục phân biệt ngọng l và n trong các ngữ cảnh đời sống thường nhật. Tranh tài đỉnh cao giọng thủ đô!',
    'WEEKLY',
    'ACTIVE',
    'NORTH',
    NOW() - INTERVAL '1 day',
    NOW() + INTERVAL '6 days',
    100,
    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80',
    '{"firstPrize": "500 XP + Huy Hiệu Vương Miện", "secondPrize": "300 XP", "thirdPrize": "150 XP"}',
    NOW() - INTERVAL '2 days', NOW()
),
(
    '00000000-0000-0008-0001-000000000003',
    'Đại Chiến Giọng Miền Trung - Tuần 2',
    'Thử tài phân biệt âm quặt lưỡi tr/ch và âm xát s/x đậm chất xứ Huế và miền Trung di sản.',
    'WEEKLY',
    'UPCOMING',
    'CENTRAL',
    NOW() + INTERVAL '6 days',
    NOW() + INTERVAL '13 days',
    150,
    'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80',
    '{"firstPrize": "600 XP + Huy Hiệu Di Sản", "secondPrize": "350 XP", "thirdPrize": "200 XP"}',
    NOW(), NOW()
),
(
    '00000000-0000-0008-0001-000000000004',
    'Siêu Cúp Phát Âm Toàn Quốc 2026',
    'Giải đấu liên miền quy tụ các học viên xuất sắc nhất cả nước. Tổng kết tháng với vô vàn phần thưởng hấp dẫn!',
    'MONTHLY',
    'UPCOMING',
    'GLOBAL',
    NOW() + INTERVAL '13 days',
    NOW() + INTERVAL '27 days',
    300,
    'https://images.unsplash.com/photo-1544717305-2782549b5136?w=800&q=80',
    '{"firstPrize": "1000 XP + Cúp Vàng Quốc Gia", "secondPrize": "600 XP", "thirdPrize": "400 XP"}',
    NOW(), NOW()
),
(
    '00000000-0000-0008-0001-000000000005',
    'Đấu Trường Phản Xạ Nhanh - Tuần 4',
    'Luyện phát xạ ngữ âm tốc độ cao kết hợp mini games. Bứt phá giới hạn phát âm lưu loát.',
    'WEEKLY',
    'UPCOMING',
    'GLOBAL',
    NOW() + INTERVAL '20 days',
    NOW() + INTERVAL '34 days',
    200,
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
    '{"firstPrize": "500 XP", "secondPrize": "300 XP", "thirdPrize": "150 XP"}',
    NOW(), NOW()
);

-- TOURNAMENT PARTICIPANTS
INSERT INTO tournament_participant (
    id, tournament_id, account_id, rank_position, total_xp, challenges_completed, average_score, status, joined_at
) VALUES
-- Tournament 1 (South)
(gen_random_uuid(), '00000000-0000-0008-0001-000000000001', '00000000-0000-0000-0002-000000000011', 1, 450, 10, 96.0, 'ACTIVE', NOW() - INTERVAL '2 days'),
(gen_random_uuid(), '00000000-0000-0008-0001-000000000001', '00000000-0000-0000-0002-000000000002', 2, 380, 8, 93.5, 'ACTIVE', NOW() - INTERVAL '1 day'), -- Demo Learner!
(gen_random_uuid(), '00000000-0000-0008-0001-000000000001', '00000000-0000-0000-0002-000000000014', 3, 310, 7, 90.0, 'ACTIVE', NOW() - INTERVAL '1 day'),
(gen_random_uuid(), '00000000-0000-0008-0001-000000000001', '00000000-0000-0000-0002-000000000017', 4, 220, 5, 87.0, 'ACTIVE', NOW() - INTERVAL '12 hours'),

-- Tournament 2 (North)
(gen_random_uuid(), '00000000-0000-0008-0001-000000000002', '00000000-0000-0000-0002-000000000010', 1, 520, 12, 97.5, 'ACTIVE', NOW() - INTERVAL '1 day'),
(gen_random_uuid(), '00000000-0000-0008-0001-000000000002', '00000000-0000-0000-0002-000000000013', 2, 420, 9, 92.0, 'ACTIVE', NOW() - INTERVAL '20 hours'),
(gen_random_uuid(), '00000000-0000-0008-0001-000000000002', '00000000-0000-0000-0002-000000000003', 3, 390, 8, 91.5, 'ACTIVE', NOW() - INTERVAL '18 hours'),
(gen_random_uuid(), '00000000-0000-0008-0001-000000000002', '00000000-0000-0000-0002-000000000016', 4, 260, 6, 88.0, 'ACTIVE', NOW() - INTERVAL '10 hours');

-- 7. MINIGAME CHALLENGES (WORD_CHALLENGE & SENTENCE_COMPLETION)
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

-- 8. CHAT MESSAGES
INSERT INTO chat_message (id, sender_id, recipient_id, content, "timestamp", status, created_at, updated_at) VALUES
('00000000-0000-0006-0002-000000000001', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'Chào bạn, hôm nay bạn đã luyện phát âm âm n/l chưa?', NOW() - INTERVAL '4 hours', 'READ', NOW() - INTERVAL '4 hours', NOW()),
('00000000-0000-0006-0002-000000000002', '00000000-0000-0000-0002-000000000003', '00000000-0000-0000-0002-000000000002', 'Mình vừa hoàn thành xong 3 thử thách hàng ngày rồi, được 95% điểm nè!', NOW() - INTERVAL '3 hours', 'READ', NOW() - INTERVAL '3 hours', NOW()),
('00000000-0000-0006-0002-000000000003', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'Tuyệt vời quá! Tuần này cố gắng giữ vị trí top bảng xếp hạng giải đấu nhé!', NOW() - INTERVAL '1 hour', 'READ', NOW() - INTERVAL '1 hour', NOW()),
('00000000-0000-0006-0002-000000000004', '00000000-0000-0000-0002-000000000003', '00000000-0000-0000-0002-000000000002', 'Nhất trí luôn bạn ơi! Tối nay cùng vào luyện thêm 15 phút bài âm tr/ch nhé.', NOW() - INTERVAL '30 minutes', 'READ', NOW() - INTERVAL '30 minutes', NOW()),
('00000000-0000-0006-0002-000000000005', '00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0002-000000000003', 'Okie bạn nhé, hẹn gặp lại tối nay! 🎉', NOW() - INTERVAL '10 minutes', 'READ', NOW() - INTERVAL '10 minutes', NOW())
ON CONFLICT (id) DO UPDATE SET
    content = EXCLUDED.content,
    sender_id = EXCLUDED.sender_id,
    recipient_id = EXCLUDED.recipient_id;

-- 9. USER FEEDBACK FOR ADMIN
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

-- 10. CUSTOM LEARNING PATHS, LEVELS & PROGRESS
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

-- 11. CONTENT ITEMS (FOR SESSIONS & DETAILS)
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

-- 12. SPEAKING ATTEMPTS
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

-- 13. EDUCATOR FEEDBACK
INSERT INTO educator_feedback (
    id, educator_id, student_id, speaking_attempt_id, comment, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0009-0001-000000000001',
    '00000000-0000-0000-0002-000000000001',
    '00000000-0000-0000-0002-000000000003',
    '00000000-0000-0008-0003-000000000001',
    'Em phát âm câu này rất tự tin và tự nhiên. Phần âm n đã khắc phục tốt so với bài test đầu vào. Tiếp tục phát huy nhé!',
    'NORMAL',
    NOW() - INTERVAL '1 day',
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- 14. ACCOUNT REWARDS (UNLOCKED ACHIEVEMENTS)
INSERT INTO account_reward (id, account_id, reward_catalog_id, status, progress_value, unlocked_at, created_at, updated_at)
SELECT '00000000-0000-0011-0001-000000000001', '00000000-0000-0000-0002-000000000003', id, 'UNLOCKED', 1, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NOW()
FROM reward_catalog WHERE code = 'LEARN_FIRST_STEP' LIMIT 1
ON CONFLICT (id) DO NOTHING;

INSERT INTO account_reward (id, account_id, reward_catalog_id, status, progress_value, unlocked_at, created_at, updated_at)
SELECT '00000000-0000-0011-0001-000000000002', '00000000-0000-0000-0002-000000000003', id, 'UNLOCKED', 1, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days', NOW()
FROM reward_catalog WHERE code = 'LEARN_DILIGENT' LIMIT 1
ON CONFLICT (id) DO NOTHING;

INSERT INTO account_reward (id, account_id, reward_catalog_id, status, progress_value, unlocked_at, created_at, updated_at)
SELECT '00000000-0000-0011-0001-000000000003', '00000000-0000-0000-0002-000000000003', id, 'UNLOCKED', 1, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW()
FROM reward_catalog WHERE code = 'CONQUEROR_NORTH' LIMIT 1
ON CONFLICT (id) DO NOTHING;

-- 15. DAILY CHALLENGE ATTEMPTS
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

-- 16. LESSON PLANS FOR EDUCATOR
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

-- 17. NOTIFICATIONS
INSERT INTO notification (id, recipient_id, title, message, type, is_read, created_at) VALUES
('00000000-0000-0012-0001-000000000001', '00000000-0000-0000-0002-000000000003', 'Chào mừng đến với SpeakVN!', 'Hãy hoàn thành bài luyện tập hàng ngày để tích lũy sao và duy trì chuỗi học tập.', 'SYSTEM', FALSE, NOW() - INTERVAL '5 days'),
('00000000-0000-0012-0001-000000000002', '00000000-0000-0000-0002-000000000003', 'Nhắc nhở chuỗi học (Streak)', 'Bạn đã đạt chuỗi 7 ngày liên tiếp! Hãy giữ vững phong độ nhé.', 'REMINDER', FALSE, NOW() - INTERVAL '1 day'),
('00000000-0000-0012-0001-000000000003', '00000000-0000-0000-0002-000000000003', 'Giải đấu tuần đã mở', 'Giải Đấu Tuần SpeakVN hiện đang diễn ra. Tham gia ngay để giành thứ hạng cao nhất!', 'TOURNAMENT', FALSE, NOW() - INTERVAL '2 days'),
('00000000-0000-0012-0001-000000000004', '00000000-0000-0000-0002-000000000003', 'Đạt huy hiệu mới', 'Chúc mừng bạn đã mở khóa huy hiệu ''Chiến Binh Chăm Chỉ''!', 'ACHIEVEMENT', TRUE, NOW() - INTERVAL '3 days')
ON CONFLICT (id) DO NOTHING;

-- 18. ASSIGNMENT
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
