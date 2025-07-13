import React from 'react';
import { Container, Header, Table, Message } from 'semantic-ui-react';
import { useAuthState } from '../hooks/useAuthState';
import { useRedemptions } from '../hooks/useRedemptions';

import type { Redemption } from '../lib/api';

export default function ClaimedRewards() {
  const { isAuthenticated } = useAuthState();
  const { data: redemptions, isLoading, error } = useRedemptions();

  if (isLoading) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <Message info>
          <Message.Header>Loading...</Message.Header>
          <p>Please wait while we load your claimed rewards.</p>
        </Message>
      </Container>
    );
  }

  if (!isAuthenticated) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <Message warning>
          <Message.Header>Authentication Required</Message.Header>
          <p>Please sign in to view your claimed rewards.</p>
        </Message>
      </Container>
    );
  }

  if (error) {
    return (
      <Container style={{ marginTop: '2rem' }}>
        <Message negative>
          <Message.Header>Error Loading Rewards</Message.Header>
          <p>There was an error loading your claimed rewards. Please try again.</p>
        </Message>
      </Container>
    );
  }

  const redemptionsList = redemptions || [];

  return (
    <Container style={{ marginTop: '2rem' }}>
      <Header as="h1">My Claimed Rewards</Header>
      
      {redemptionsList.length === 0 ? (
        <Message info>
          <Message.Header>No Rewards Claimed Yet</Message.Header>
          <p>You haven't claimed any rewards yet. Head over to the rewards page to start redeeming!</p>
        </Message>
      ) : (
        <Table celled>
          <Table.Header>
            <Table.Row>
              <Table.HeaderCell>Reward Name</Table.HeaderCell>
              <Table.HeaderCell>Cost</Table.HeaderCell>
              <Table.HeaderCell>Date Claimed</Table.HeaderCell>
            </Table.Row>
          </Table.Header>
          
          <Table.Body>
            {redemptionsList.map((redemption: Redemption) => (
              <Table.Row key={redemption.id}>
                <Table.Cell>
                  {redemption.reward_name || 'Unknown Reward'}
                </Table.Cell>
                <Table.Cell>{redemption.points_cost?.toLocaleString()} points</Table.Cell>
                <Table.Cell>
                  {new Date(redemption.created_at).toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                  })}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      )}
    </Container>
  );
} 