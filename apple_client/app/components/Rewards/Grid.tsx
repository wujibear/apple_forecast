import React from 'react';
import { Grid } from 'semantic-ui-react';
import type { Reward } from '../../lib/api';
import RewardCard from './Card';

interface RewardsGridProps {
  rewards: Reward[];
  userPointsBalance?: number;
  onRedeem: (_rewardNanoid: string) => void;
  isRedeeming: boolean;
}

export default function RewardsGrid({
  rewards,
  userPointsBalance,
  onRedeem,
  isRedeeming,
}: RewardsGridProps) {
  return (
    <Grid stackable columns={3}>
      {rewards.map(reward => (
        <Grid.Column key={reward.nanoid}>
          <RewardCard
            reward={reward}
            userPointsBalance={userPointsBalance}
            onRedeem={() => onRedeem(reward.nanoid)}
            isRedeeming={isRedeeming}
          />
        </Grid.Column>
      ))}
    </Grid>
  );
}
