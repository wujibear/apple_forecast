import React from 'react';
import { Card, CardContent, Button, Icon } from 'semantic-ui-react';
import type { Reward } from '../../lib/api';

interface RewardCardProps {
  reward: Reward;
  userPointsBalance?: number;
  onRedeem: (rewardNanoid: string) => void;
  isRedeeming: boolean;
}

export default function RewardCard({ 
  reward, 
  userPointsBalance = 0, 
  onRedeem, 
  isRedeeming 
}: RewardCardProps) {
  const canRedeem = userPointsBalance >= reward.points;

  return (
    <Card fluid>
      <CardContent>
        <Card.Header>
          <Icon name="gift" />
          {reward.name}
        </Card.Header>
        <Card.Meta>
          <Icon name="star" color="yellow" />
          {reward.points} points
        </Card.Meta>
        <Card.Description>
          Redeem this reward for {reward.points} points
        </Card.Description>
      </CardContent>
      <CardContent extra>
        <Button
          fluid
          color="green"
          onClick={() => onRedeem(reward.nanoid)}
          loading={isRedeeming}
          disabled={!canRedeem}
        >
          {canRedeem ? 'Redeem Reward' : 'Not enough points'}
        </Button>
      </CardContent>
    </Card>
  );
} 