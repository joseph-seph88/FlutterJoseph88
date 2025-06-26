import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
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

    @Column({ nullable: true })
    image: string;

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

    @UpdateDateColumn()
    deletedAt: Date;

    @ManyToOne(() => CommunityBoard)
    @JoinColumn({ name: 'postId' })
    communityBoard: CommunityBoard;

    @ManyToOne(() => Comment, comment => comment.replies, { nullable: true })
    @JoinColumn({ name: 'parentCommentId' })
    parentComment: Comment;

    @OneToMany(() => Comment, comment => comment.parentComment)
    replies: Comment[];
}