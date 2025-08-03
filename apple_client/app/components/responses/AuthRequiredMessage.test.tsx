import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import AuthRequiredMessage from './AuthRequiredMessage';

describe('AuthRequiredMessage', () => {
  it('renders with default props', () => {
    render(<AuthRequiredMessage />);

    expect(screen.getByText('Authentication Required')).toBeInTheDocument();
    expect(
      screen.getByText('Please sign in to view this content.')
    ).toBeInTheDocument();
  });

  it('renders with custom title and message', () => {
    render(
      <AuthRequiredMessage
        title="Custom Auth Required"
        message="Please log in to continue"
      />
    );

    expect(screen.getByText('Custom Auth Required')).toBeInTheDocument();
    expect(screen.getByText('Please log in to continue')).toBeInTheDocument();
  });

  it('renders with only custom title', () => {
    render(<AuthRequiredMessage title="Custom Auth Title" />);

    expect(screen.getByText('Custom Auth Title')).toBeInTheDocument();
    expect(
      screen.getByText('Please sign in to view this content.')
    ).toBeInTheDocument();
  });

  it('renders with only custom message', () => {
    render(<AuthRequiredMessage message="Custom auth message only" />);

    expect(screen.getByText('Authentication Required')).toBeInTheDocument();
    expect(screen.getByText('Custom auth message only')).toBeInTheDocument();
  });
});
