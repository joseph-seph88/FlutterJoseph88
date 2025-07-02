import { Field, Int, ObjectType } from "@nestjs/graphql";
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
@ObjectType()
export class ImageEntity {
    @PrimaryGeneratedColumn()
    @Field(() => Int)
    id: number;

    @Column()
    @Field(() => Int)
    userId: number;

    @Column()
    @Field(() => Int)
    targetId: number;

    @Column()
    @Field()
    targetType: string;

    @Column()
    @Field(() => Int)
    sortedNumber: number;

    @Column()
    @Field()
    fileUrl: string;

    @Column()
    @Field()
    fileName: string;

    @Column()
    @Field()
    originalFileName: string;

    @CreateDateColumn()
    @Field()
    createdAt: Date;

    @UpdateDateColumn()
    @Field()
    updatedAt: Date;
}
