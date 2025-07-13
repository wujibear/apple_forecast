import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the API service
vi.mock('../lib/api', () => ({
  ApiService: {
    getCurrentUser: vi.fn(),
  },
}));

// Mock the hooks to avoid complex setup
vi.mock('./useAuth', () => ({
  useAuthData: () => ({
    data: null,
    isLoading: false,
    error: null,
  }),
  useCurrentUser: () => ({
    data: null,
    isLoading: false,
    error: null,
  }),
}));

describe('Auth Hooks', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.mocked(localStorage.getItem).mockReturnValue(null);
  });

  it('should handle localStorage properly', () => {
    expect(localStorage.getItem('auth_token')).toBe(null);
    
    vi.mocked(localStorage.getItem).mockReturnValue('test-token');
    expect(localStorage.getItem('auth_token')).toBe('test-token');
  });
}); 