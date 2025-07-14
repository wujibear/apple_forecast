import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import PointsBalance from './PointsBalance';

describe('PointsBalance', () => {
  it('renders points balance', () => {
    render(<PointsBalance pointsBalance={1000} />);

    expect(screen.getByText('Your Points Balance: 1000')).toBeInTheDocument();
  });

  it('renders zero points balance', () => {
    render(<PointsBalance pointsBalance={0} />);

    expect(screen.getByText('Your Points Balance: 0')).toBeInTheDocument();
  });

  it('renders large points balance', () => {
    render(<PointsBalance pointsBalance={999999} />);

    expect(screen.getByText('Your Points Balance: 999999')).toBeInTheDocument();
  });
});
