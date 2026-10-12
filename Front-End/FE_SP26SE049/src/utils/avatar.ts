/**
 * Tiện ích hỗ trợ Avatar cho toàn hệ thống SpeakVN
 * Đảm bảo không bao giờ bị trống hoặc lỗi hiển thị
 */
export function getAvatarUrl(
    url?: string | null,
    name?: string | null,
    style: 'adventurer' | 'bottts' | 'initials' = 'adventurer'
): string {
    if (url && typeof url === 'string' && url.trim() !== '') {
        return url;
    }
    const seed = encodeURIComponent((name && name.trim()) || 'HocVienSpeakVN');
    return `https://api.dicebear.com/7.x/${style}/svg?seed=${seed}`;
}

export function getInitials(name?: string | null): string {
    if (!name || typeof name !== 'string') return 'HV';
    const parts = name.trim().split(/\s+/);
    if (parts.length === 0) return 'HV';
    if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}
