// DTO describing the structured filters coming from the NLP step
import {
  IsOptional,
  IsInt,
  IsString,
  IsIn,
  Min,
} from 'class-validator';

export class QueryFiltersDto {
  @IsOptional() @IsInt() @Min(1)
  warehouse_id?: number;

  @IsOptional() @IsInt() @Min(1)
  material_id?: number;

  @IsOptional() @IsString()
  material_type?: string;

  @IsOptional() @IsString()
  material_group?: string;

  @IsOptional() @IsString()
  personnel_id?: string;

  @IsOptional() @IsString() // format YYYYMMDD
  date_from?: string;

  @IsOptional() @IsString()
  date_to?: string;

    @IsOptional() @IsString()
  first_name?: string;
  
  @IsOptional() @IsString()
  last_name?: string;

  @IsOptional()
  @IsIn(['sum','count','list','by_material','by_group','by_type','top'])
  aggregate: string = 'sum';

  @IsOptional() @IsInt() @Min(1)
  top_k?: number = 10;
}
