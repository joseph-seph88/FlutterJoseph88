import { ObjectType, Field, Int } from '@nestjs/graphql';

@ObjectType()
export class BasicResponse {
    @Field(() => Int)
    statusCode: number;

    @Field()
    message: string;
}