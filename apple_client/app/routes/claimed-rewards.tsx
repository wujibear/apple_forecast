import React from 'react';
import { Container, Header } from 'semantic-ui-react';
import { useAuthState } from '../hooks/useAuthState';
import { useRedemptions } from '../hooks/useRedemptions';
import {
  LoadingMessage,
  ErrorMessage,
  AuthRequiredMessage,
} from '../components/responses';
import {
  Table as ClaimedRewardsTable,
  Empty as ClaimedRewardsEmpty,
} from '../components/ClaimedRewards';

export default function ClaimedRewards() {
  const { isAuthenticated } = useAuthState();
  const { data: redemptions, isLoading, error } = useRedemptions();

  if (isLoading) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <LoadingMessage
          title="Loading..."
          message="Please wait while we load your claimed rewards."
        />
      </Container>
    );
  }

  if (!isAuthenticated) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <AuthRequiredMessage
          title="Authentication Required"
          message="Please sign in to view your claimed rewards."
        />
      </Container>
    );
  }

  if (error) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <ErrorMessage
          title="Error Loading Rewards"
          message="There was an error loading your claimed rewards. Please try again."
        />
      </Container>
    );
  }

  const redemptionsList = redemptions || [];

  return (
    <Container style={{ marginTop: '2rem' }}>
      <Header as="h1">My Claimed Rewards</Header>

      {redemptionsList.length === 0 ? (
        <ClaimedRewardsEmpty />
      ) : (
        <ClaimedRewardsTable redemptions={redemptionsList} />
      )}
    </Container>
  );
}
