import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import LoadingMessage from './LoadingMessage';

describe('LoadingMessage', () => {
  it('renders with default props', () => {
    render(<LoadingMessage />);

    expect(screen.getByText('Loading...')).toBeInTheDocument();
    expect(
      screen.getByText('Please wait while we load your data.')
    ).toBeInTheDocument();
  });

  it('renders with custom title and message', () => {
    render(
      <LoadingMessage
        title="Custom Loading"
        message="Please wait for custom data"
      />
    );

    expect(screen.getByText('Custom Loading')).toBeInTheDocument();
    expect(screen.getByText('Please wait for custom data')).toBeInTheDocument();
  });

  it('renders with only custom title', () => {
    render(<LoadingMessage title="Custom Title" />);

    expect(screen.getByText('Custom Title')).toBeInTheDocument();
    expect(
      screen.getByText('Please wait while we load your data.')
    ).toBeInTheDocument();
  });

  it('renders with only custom message', () => {
    render(<LoadingMessage message="Custom message only" />);

    expect(screen.getByText('Loading...')).toBeInTheDocument();
    expect(screen.getByText('Custom message only')).toBeInTheDocument();
  });
});
