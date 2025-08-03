import React from 'react';
import { Container, Header, Segment, Button, Icon } from 'semantic-ui-react';
import { Link } from 'react-router';
import { useAuthState } from '../../hooks/useAuthState';

export default function HomeWelcome() {
  const { isAuthenticated, user } = useAuthState();

  return (
    <Container text>
      <Segment textAlign="center" style={{ marginTop: '2rem' }}>
        <Header as="h1" icon>
          <Icon name="gift" />
          Apple Rewards
          <Header.Subheader>
            Earn points and redeem amazing rewards
          </Header.Subheader>
        </Header>

        {isAuthenticated && user ? (
          <div>
            <Header as="h3" color="blue">
              Welcome back! You have {user.points_balance} points
            </Header>
            <Button.Group size="large">
              <Button as={Link} to="/rewards" color="green">
                <Icon name="gift" />
                Browse Rewards
              </Button>
              <Button as={Link} to="/claimed-rewards" color="blue">
                <Icon name="list" />
                My Rewards
              </Button>
            </Button.Group>
          </div>
        ) : (
          <div>
            <Header as="h3" color="grey">
              Sign in to start earning points
            </Header>
            <Button as={Link} to="/login" size="large" color="green">
              <Icon name="sign in" />
              Sign In
            </Button>
          </div>
        )}
      </Segment>
    </Container>
  );
}
