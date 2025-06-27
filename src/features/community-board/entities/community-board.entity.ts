import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany, DeleteDateColumn } from 'typeorm';
import { Comment } from '../../comment/entities/comment.entity';
import { ObjectType, Field, Int } from '@nestjs/graphql';

@Entity('community_board')
@ObjectType()
export class CommunityBoard {
    @PrimaryGeneratedColumn()
    @Field(() => Int)
    id: number;

    @Column()
    @Field()
    title: string;

    @Column('text')
    @Field()
    content: string;

    @Column()
    @Field()
    category: string;

    @Column('simple-array', { nullable: true })
    @Field(() => [String], { nullable: true })
    images?: string[];

    @Column()
    @Field(() => Int)
    writerId: number;

    @Column()
    @Field()
    writerName: string;

    @Column({ nullable: true })
    @Field({ nullable: true })
    writerProfileImage?: string;

    @Column({ default: 0 })
    @Field(() => Int)
    viewCount: number;

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

    @OneToMany(() => Comment, comment => comment.communityBoard)
    @Field(() => [Comment], { nullable: true })
    comments: Comment[];
}
