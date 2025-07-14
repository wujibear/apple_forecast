import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import ErrorMessage from './ErrorMessage';

describe('ErrorMessage', () => {
  it('renders with default props', () => {
    render(<ErrorMessage />);

    expect(screen.getByText('Error')).toBeInTheDocument();
    expect(
      screen.getByText(
        'There was an error loading your data. Please try again.'
      )
    ).toBeInTheDocument();
  });

  it('renders with custom title and message', () => {
    render(
      <ErrorMessage title="Custom Error" message="Something went wrong" />
    );

    expect(screen.getByText('Custom Error')).toBeInTheDocument();
    expect(screen.getByText('Something went wrong')).toBeInTheDocument();
  });

  it('renders with only custom title', () => {
    render(<ErrorMessage title="Custom Error Title" />);

    expect(screen.getByText('Custom Error Title')).toBeInTheDocument();
    expect(
      screen.getByText(
        'There was an error loading your data. Please try again.'
      )
    ).toBeInTheDocument();
  });

  it('renders with only custom message', () => {
    render(<ErrorMessage message="Custom error message only" />);

    expect(screen.getByText('Error')).toBeInTheDocument();
    expect(screen.getByText('Custom error message only')).toBeInTheDocument();
  });
});
