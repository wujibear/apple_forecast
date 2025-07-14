import React from 'react';
import { Container, Header, Icon, Loader } from 'semantic-ui-react';
import { useRewards, useRedeemReward } from '../hooks/useRewards';
import { useAuthState } from '../hooks/useAuthState';
import { LoadingMessage, ErrorMessage } from '../components/responses';
import { Grid, Empty, PointsBalance } from '../components/Rewards';
import 'semantic-ui-css/semantic.min.css';

export default function RewardsPage() {
  const { data: rewards, isLoading, error } = useRewards();
  const { user } = useAuthState();
  const redeemMutation = useRedeemReward();

  const handleRedeem = async (rewardNanoid: string) => {
    try {
      await redeemMutation.mutateAsync(rewardNanoid);
    } catch (error) {
      console.error('Failed to redeem reward:', error);
    }
  };

  if (isLoading) {
    return (
      <Container textAlign="center" style={{ marginTop: '2rem' }}>
        <Loader active size="large">
          Loading rewards...
        </Loader>
      </Container>
    );
  }

  if (error) {
    return (
      <Container>
        <ErrorMessage
          title="Error loading rewards"
          message="Please try again later."
        />
      </Container>
    );
  }

  const rewardsList = rewards || [];

  return (
    <Container>
      <Header as="h1" textAlign="center">
        <Icon name="gift" />
        Available Rewards
      </Header>

      {user && <PointsBalance pointsBalance={user.points_balance} />}

      {rewardsList.length === 0 ? (
        <Empty />
      ) : (
        <Grid
          rewards={rewardsList}
          userPointsBalance={user?.points_balance}
          onRedeem={handleRedeem}
          isRedeeming={redeemMutation.isPending}
        />
      )}
    </Container>
  );
}
