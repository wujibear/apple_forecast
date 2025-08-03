import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import ClaimedRewardsEmpty from './Empty';

describe('ClaimedRewardsEmpty', () => {
  it('renders empty state message', () => {
    render(<ClaimedRewardsEmpty />);

    expect(screen.getByText('No Rewards Claimed Yet')).toBeInTheDocument();
    expect(
      screen.getByText(/You haven't claimed any rewards yet/)
    ).toBeInTheDocument();
    expect(
      screen.getByText(/Head over to the rewards page/)
    ).toBeInTheDocument();
  });
});
