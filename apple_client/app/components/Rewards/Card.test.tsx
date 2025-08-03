import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import RewardCard from './Card';

const mockReward = {
  nanoid: 'test-nanoid',
  name: 'Test Reward',
  points: 500,
  created_at: '2023-01-01T00:00:00Z',
  updated_at: '2023-01-01T00:00:00Z',
};

describe('RewardCard', () => {
  it('renders reward information', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={1000}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );

    expect(screen.getByText('Test Reward')).toBeInTheDocument();
    expect(screen.getByText('500 points')).toBeInTheDocument();
    expect(
      screen.getByText('Redeem this reward for 500 points')
    ).toBeInTheDocument();
    expect(screen.getByText('Redeem Reward')).toBeInTheDocument();
  });

  it('calls onRedeem when redeem button is clicked', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={1000}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );

    fireEvent.click(screen.getByText('Redeem Reward'));
    expect(onRedeem).toHaveBeenCalledWith();
  });

  it('shows loading state when isRedeeming is true', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={1000}
        onRedeem={onRedeem}
        isRedeeming={true}
      />
    );

    const button = screen.getByText('Redeem Reward');
    expect(button).toHaveClass('loading');
  });

  it('disables button when user has insufficient points', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={300}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );

    expect(screen.getByText('Not enough points')).toBeInTheDocument();
    expect(screen.getByText('Not enough points')).toBeDisabled();
  });

  it('disables button when user has exactly enough points', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={500}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );

    expect(screen.getByText('Redeem Reward')).toBeInTheDocument();
    expect(screen.getByText('Redeem Reward')).not.toBeDisabled();
  });

  it('disables button when userPointsBalance is undefined', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard reward={mockReward} onRedeem={onRedeem} isRedeeming={false} />
    );

    expect(screen.getByText('Not enough points')).toBeInTheDocument();
    expect(screen.getByText('Not enough points')).toBeDisabled();
  });

  it('disables button when userPointsBalance is 0', () => {
    const onRedeem = vi.fn();
    render(
      <RewardCard
        reward={mockReward}
        userPointsBalance={0}
        onRedeem={onRedeem}
        isRedeeming={false}
      />
    );

    expect(screen.getByText('Not enough points')).toBeInTheDocument();
    expect(screen.getByText('Not enough points')).toBeDisabled();
  });
});
