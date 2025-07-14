import { describe, it, expect, vi, beforeEach } from 'vitest';
import { screen } from '@testing-library/react';
import { renderWithProviders } from '../../test/utils';
import HomeWelcome from './Welcome';

// Mock the useAuthState hook
vi.mock('../../hooks/useAuthState', () => ({
  useAuthState: vi.fn(),
}));

// Get the mocked function after the mock is set up
let mockUseAuthState: any;

describe('HomeWelcome', () => {
  beforeEach(async () => {
    vi.clearAllMocks();
    const { useAuthState } = await import('../../hooks/useAuthState');
    mockUseAuthState = vi.mocked(useAuthState);
  });

  it('renders welcome message for unauthenticated users', () => {
    mockUseAuthState.mockReturnValue({
      isAuthenticated: false,
      user: null,
      isLoading: false,
    });

    renderWithProviders(<HomeWelcome />);

    expect(screen.getByText('Thanx Rewards')).toBeInTheDocument();
    expect(
      screen.getByText('Earn points and redeem amazing rewards')
    ).toBeInTheDocument();
    expect(
      screen.getByText('Sign in to start earning points')
    ).toBeInTheDocument();
    expect(screen.getByText('Sign In')).toBeInTheDocument();
  });

  it('renders welcome message for authenticated users', () => {
    mockUseAuthState.mockReturnValue({
      isAuthenticated: true,
      user: {
        nanoid: 'user-nanoid',
        email_address: 'test@example.com',
        points_balance: 1000,
        created_at: '2023-01-01T00:00:00Z',
        updated_at: '2023-01-01T00:00:00Z',
      },
      isLoading: false,
    });

    renderWithProviders(<HomeWelcome />);

    expect(screen.getByText('Thanx Rewards')).toBeInTheDocument();
    expect(
      screen.getByText('Earn points and redeem amazing rewards')
    ).toBeInTheDocument();
    expect(
      screen.getByText('Welcome back! You have 1000 points')
    ).toBeInTheDocument();
    expect(screen.getByText('Browse Rewards')).toBeInTheDocument();
    expect(screen.getByText('My Rewards')).toBeInTheDocument();
  });

  it('renders welcome message for authenticated users with zero points', () => {
    mockUseAuthState.mockReturnValue({
      isAuthenticated: true,
      user: {
        nanoid: 'user-nanoid',
        email_address: 'test@example.com',
        points_balance: 0,
        created_at: '2023-01-01T00:00:00Z',
        updated_at: '2023-01-01T00:00:00Z',
      },
      isLoading: false,
    });

    renderWithProviders(<HomeWelcome />);

    expect(
      screen.getByText('Welcome back! You have 0 points')
    ).toBeInTheDocument();
  });

  it('renders welcome message for authenticated users with large points balance', () => {
    mockUseAuthState.mockReturnValue({
      isAuthenticated: true,
      user: {
        nanoid: 'user-nanoid',
        email_address: 'test@example.com',
        points_balance: 999999,
        created_at: '2023-01-01T00:00:00Z',
        updated_at: '2023-01-01T00:00:00Z',
      },
      isLoading: false,
    });

    renderWithProviders(<HomeWelcome />);

    expect(
      screen.getByText('Welcome back! You have 999999 points')
    ).toBeInTheDocument();
  });
});
