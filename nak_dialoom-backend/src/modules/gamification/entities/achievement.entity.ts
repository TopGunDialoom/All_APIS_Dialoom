import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Achievement {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 0 })
  points: number;
}
