import React from 'react';
import { Segment, Header } from 'semantic-ui-react';

interface PointsBalanceProps {
  pointsBalance: number;
}

export default function PointsBalance({ pointsBalance }: PointsBalanceProps) {
  return (
    <Segment textAlign="center" color="blue">
      <Header as="h3">
        Your Points Balance: {pointsBalance}
      </Header>
    </Segment>
  );
} 