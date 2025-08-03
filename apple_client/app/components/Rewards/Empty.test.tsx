import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import RewardsEmpty from './Empty';

describe('RewardsEmpty', () => {
  it('renders empty state message', () => {
    render(<RewardsEmpty />);

    expect(screen.getByText('No rewards available')).toBeInTheDocument();
    expect(
      screen.getByText('Check back later for new rewards!')
    ).toBeInTheDocument();
  });
});
