import React from 'react';
import { Message } from 'semantic-ui-react';

export default function RewardsEmpty() {
  return (
    <Message info>
      <Message.Header>No rewards available</Message.Header>
      <p>Check back later for new rewards!</p>
    </Message>
  );
} 