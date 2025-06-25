import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { CommunityBoard } from './community-board.entity';

@Entity('comments')
export class Comment {
    @PrimaryGeneratedColumn()
    id: number;

    @Column('text')
    content: string;

    @Column()
    postId: number;

    @Column()
    writerId: number;

    @Column()
    writerName: string;

    @Column({ nullable: true })
    writerProfileImage: string;

    @Column('simple-array', { nullable: true })
    images: string[];

    @Column({ nullable: true })
    parentCommentId: number;

    @Column({ default: 0 })
    likeCount: number;

    @Column({ nullable: true })
    deletedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;

    @ManyToOne(() => CommunityBoard)
    @JoinColumn({ name: 'postId' })
    communityBoard: CommunityBoard;
}