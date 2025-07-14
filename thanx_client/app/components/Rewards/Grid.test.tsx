import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import RewardsGrid from './Grid';

const mockReward = {
  nanoid: 'test-nanoid',
  name: 'Test Reward',
  points: 500,
  created_at: '2023-01-01T00:00:00Z',
  updated_at: '2023-01-01T00:00:00Z'
};

describe('RewardsGrid', () => {
  it('renders grid with rewards', () => {
    const onRedeem = vi.fn();
    const rewards = [mockReward];
    
    render(
      <RewardsGrid 
        rewards={rewards}
        userPointsBalance={1000}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );
    
    expect(screen.getByText('Test Reward')).toBeInTheDocument();
    expect(screen.getByText('500 points')).toBeInTheDocument();
  });

  it('renders multiple rewards', () => {
    const onRedeem = vi.fn();
    const rewards = [
      mockReward,
      { ...mockReward, nanoid: 'test-nanoid-2', name: 'Second Reward', points: 1000 }
    ];
    
    render(
      <RewardsGrid 
        rewards={rewards}
        userPointsBalance={1000}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );
    
    expect(screen.getByText('Test Reward')).toBeInTheDocument();
    expect(screen.getByText('Second Reward')).toBeInTheDocument();
    expect(screen.getByText('500 points')).toBeInTheDocument();
    expect(screen.getByText('1000 points')).toBeInTheDocument();
  });

  it('passes correct props to reward cards', () => {
    const onRedeem = vi.fn();
    const rewards = [mockReward];
    
    render(
      <RewardsGrid 
        rewards={rewards}
        userPointsBalance={750}
        onRedeem={onRedeem}
        isRedeeming={true}
      />
    );
    
    // Should render the reward card with the passed props
    expect(screen.getByText('Test Reward')).toBeInTheDocument();
  });
}); 