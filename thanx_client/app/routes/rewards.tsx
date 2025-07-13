import { useRewards, useRedeemReward } from '../hooks/useRewards';
import { useAuthState } from '../hooks/useAuthState';
import { 
  Container, 
  Grid, 
  Card, 
  CardContent, 
  Button, 
  Header, 
  Segment,
  Loader,
  Message,
  Icon
} from 'semantic-ui-react';
import 'semantic-ui-css/semantic.min.css';

export default function RewardsPage() {
  const { data: rewards, isLoading, error } = useRewards();
  const { user } = useAuthState();
  const redeemMutation = useRedeemReward();

  const handleRedeem = async (rewardId: number) => {
    try {
      await redeemMutation.mutateAsync(rewardId);
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
        <Message negative>
          <Message.Header>Error loading rewards</Message.Header>
          <p>Please try again later.</p>
        </Message>
      </Container>
    );
  }

  return (
    <>
      <Header as="h1" textAlign="center">
        <Icon name="gift" />
        Available Rewards
      </Header>
      
      {user && (
        <Segment textAlign="center" color="blue">
          <Header as="h3">
            Your Points Balance: {user.points_balance}
          </Header>
        </Segment>
      )}

      <Grid stackable columns={3}>
        {rewards?.map((reward) => (
          <Grid.Column key={reward.id}>
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
                  onClick={() => handleRedeem(reward.id)}
                  loading={redeemMutation.isPending}
                  disabled={!user || user.points_balance < reward.points}
                >
                  {user && user.points_balance < reward.points 
                    ? 'Not enough points' 
                    : 'Redeem Reward'
                  }
                </Button>
              </CardContent>
            </Card>
          </Grid.Column>
        ))}
      </Grid>

      {rewards?.length === 0 && (
        <Message info>
          <Message.Header>No rewards available</Message.Header>
          <p>Check back later for new rewards!</p>
        </Message>
      )}
    </>
  );
} 