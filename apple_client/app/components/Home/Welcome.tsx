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
          Apple Forecast
          <Header.Subheader>
            See your local weather forecast
          </Header.Subheader>
        </Header>
      </Segment>
    </Container>
  );
}
