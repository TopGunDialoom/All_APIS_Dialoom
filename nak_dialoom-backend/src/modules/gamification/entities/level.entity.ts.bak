import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Level {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  levelNumber: number;

  @Column()
  requiredPoints: number;
}
