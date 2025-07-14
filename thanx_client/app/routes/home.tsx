import { Welcome } from '../components/Home';

export function meta() {
  return [
    { title: 'Thanx Rewards' },
    { name: 'description', content: 'Earn points and redeem amazing rewards' },
  ];
}

export default function Home() {
  return <Welcome />;
}
