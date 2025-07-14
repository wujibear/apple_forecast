import React from 'react';
import { Table } from 'semantic-ui-react';
import type { Redemption } from '../../lib/api';

interface ClaimedRewardsTableProps {
  redemptions: Redemption[];
}

export default function ClaimedRewardsTable({ redemptions }: ClaimedRewardsTableProps) {
  if (redemptions.length === 0) {
    return null;
  }

  return (
    <Table celled>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell>Reward Name</Table.HeaderCell>
          <Table.HeaderCell>Cost</Table.HeaderCell>
          <Table.HeaderCell>Date Claimed</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      
      <Table.Body>
        {redemptions.map((redemption: Redemption) => (
          <Table.Row key={redemption.nanoid}>
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
  );
} 