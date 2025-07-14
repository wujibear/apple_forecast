import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import ClaimedRewardsTable from './Table';

const mockRedemption = {
  nanoid: 'test-nanoid',
  user_nanoid: 'user-nanoid',
  reward_nanoid: 'reward-nanoid',
  points_cost: 500,
  reward_name: 'Test Reward',
  created_at: '2023-01-01T00:00:00Z',
  updated_at: '2023-01-01T00:00:00Z',
};

describe('ClaimedRewardsTable', () => {
  it('renders table with redemptions', () => {
    const redemptions = [mockRedemption];
    render(<ClaimedRewardsTable redemptions={redemptions} />);

    expect(screen.getByText('Reward Name')).toBeInTheDocument();
    expect(screen.getByText('Cost')).toBeInTheDocument();
    expect(screen.getByText('Date Claimed')).toBeInTheDocument();
    expect(screen.getByText('Test Reward')).toBeInTheDocument();
    expect(screen.getByText('500 points')).toBeInTheDocument();
  });

  it('renders multiple redemptions', () => {
    const redemptions = [
      mockRedemption,
      {
        ...mockRedemption,
        nanoid: 'test-nanoid-2',
        reward_name: 'Second Reward',
        points_cost: 1000,
      },
    ];
    render(<ClaimedRewardsTable redemptions={redemptions} />);

    expect(screen.getByText('Test Reward')).toBeInTheDocument();
    expect(screen.getByText('Second Reward')).toBeInTheDocument();
    expect(screen.getByText('500 points')).toBeInTheDocument();
    expect(screen.getByText('1,000 points')).toBeInTheDocument();
  });

  it('renders unknown reward when reward_name is empty string', () => {
    const redemptions = [{ ...mockRedemption, reward_name: '' }];
    render(<ClaimedRewardsTable redemptions={redemptions} />);

    expect(screen.getByText('Unknown Reward')).toBeInTheDocument();
  });

  it('formats date correctly', () => {
    const redemptions = [
      { ...mockRedemption, created_at: '2023-12-25T15:30:00Z' },
    ];
    render(<ClaimedRewardsTable redemptions={redemptions} />);

    // Should format as "December 25, 2023 at 03:30 PM" (or similar locale format)
    expect(screen.getByText(/December 25, 2023/)).toBeInTheDocument();
  });

  it('returns null when redemptions array is empty', () => {
    const { container } = render(<ClaimedRewardsTable redemptions={[]} />);

    // Should render nothing
    expect(container.firstChild).toBeNull();
  });
});
