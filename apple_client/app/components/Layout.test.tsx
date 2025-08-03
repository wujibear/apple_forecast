import { describe, it, expect, vi } from 'vitest';
import { screen } from '@testing-library/react';
import { renderWithProviders } from '../test/utils';
import Layout from './Layout';

// Mock the auth HOOKS
vi.mock('../hooks/useAuthState', () => ({
  useAuthState: () => ({
    user: null,
    isLoading: false,
    isAuthenticated: false,
  }),
}));

vi.mock('../hooks/useAuth', () => ({
  useLogin: () => ({
    mutate: vi.fn(),
    isPending: false,
    error: null,
  }),
  useLogout: () => ({
    mutate: vi.fn(),
    isPending: false,
  }),
}));

describe('Layout', () => {
  it('renders the header with Apple Rewards title', () => {
    renderWithProviders(<Layout>Test content</Layout>);

    expect(screen.getByText('Apple Rewards')).toBeInTheDocument();
    expect(screen.getByText('Test content')).toBeInTheDocument();
  });

  it('shows sign in button when user is not authenticated', () => {
    renderWithProviders(<Layout>Test content</Layout>);

    expect(screen.getByText('Sign In')).toBeInTheDocument();
  });

  it('renders children content', () => {
    const testContent = 'This is test content';
    renderWithProviders(<Layout>{testContent}</Layout>);

    expect(screen.getByText(testContent)).toBeInTheDocument();
  });
});
