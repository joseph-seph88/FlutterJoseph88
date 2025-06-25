import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Comment } from './comment.entity';

@Entity('community_board')
export class CommunityBoard {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    title: string;

    @Column('text')
    content: string;

    @Column()
    category: string;

    @Column('simple-array', { nullable: true })
    images: string[];

    @Column()
    writerId: number;

    @Column()
    writerName: string;

    @Column({ nullable: true })
    writerProfileImage: string;

    @Column({ default: 0 })
    viewCount: number;

    @Column({ default: 0 })
    likeCount: number;

    @Column({ nullable: true })
    deletedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;

    @OneToMany(() => Comment, comment => comment.communityBoard)
    comments: Comment[];
}
