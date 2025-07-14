import React from 'react';
import { Message } from 'semantic-ui-react';

export default function ClaimedRewardsEmpty() {
  return (
    <Message info>
      <Message.Header>No Rewards Claimed Yet</Message.Header>
      <p>
        You haven't claimed any rewards yet. Head over to the rewards page to
        start redeeming!
      </p>
    </Message>
  );
}
