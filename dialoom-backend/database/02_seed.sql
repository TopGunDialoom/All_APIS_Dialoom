INSERT INTO users (email, password, name, role)
VALUES
('admin@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'Admin', 'superadmin'),
('host1@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'Host1', 'host'),
('user1@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'User1', 'user');

INSERT INTO badges (name, description, points_required)
VALUES
('FirstCall', 'Badge for completing the first call', 0),
('StarHost', 'Badge for hosts with 100% 5-star reviews', 0);

