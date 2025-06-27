import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany, DeleteDateColumn } from 'typeorm';
import { CommunityBoard } from '../../community-board/entities/community-board.entity';
import { ObjectType, Field, Int } from '@nestjs/graphql';

@Entity('comments')
@ObjectType()
export class Comment {
    @PrimaryGeneratedColumn()
    @Field(() => Int)
    id: number;

    @Column('text')
    @Field()
    content: string;

    @Column()
    @Field(() => Int)
    postId: number;

    @Column()
    @Field(() => Int)
    writerId: number;

    @Column()
    @Field()
    writerName: string;

    @Column({ nullable: true })
    @Field({ nullable: true })
    writerProfileImage?: string;

    @Column({ nullable: true })
    @Field({ nullable: true })
    image?: string;

    @Column({ nullable: true })
    @Field(() => Int, { nullable: true })
    parentCommentId: number;

    @Column({ default: 0 })
    @Field(() => Int)
    likeCount: number;

    @Column({ nullable: true })
    @Field({ nullable: true })
    deletedBy?: string;

    @CreateDateColumn()
    @Field()
    createdAt: Date;

    @UpdateDateColumn()
    @Field()
    updatedAt: Date;

    @DeleteDateColumn({ nullable: true })
    deletedAt: Date;

    @ManyToOne(() => CommunityBoard)
    @Field(() => CommunityBoard)
    @JoinColumn({ name: 'postId' })
    communityBoard: CommunityBoard;

    @ManyToOne(() => Comment, comment => comment.replies, { nullable: true })
    @Field(() => Comment, { nullable: true })
    @JoinColumn({ name: 'parentCommentId' })
    parentComment: Comment;

    @OneToMany(() => Comment, comment => comment.parentComment)
    @Field(() => [Comment], { nullable: true })
    replies: Comment[];
}