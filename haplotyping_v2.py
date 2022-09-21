import pandas as pd
import numpy as np
import sys
threshold = np.log(0.9)


st_path = sys.argv[1]
choice = sys.argv[2]

def variant_filtering(save=True):
	variants = pd.read_csv(f'{st_path}per_read_variant_calls.txt', delimiter = '\t')

	variants['pos'] = np.where((variants['pos'] < 2120),
		variants['pos']-2120, variants['pos']-2120+1)

	variants = variants.loc[(variants['pos'] <= 16000) &
		(((variants['ref_log_prob'] >= threshold) & (variants['alt_log_prob'] < threshold)) |
		((variants['ref_log_prob'] < threshold) & (variants['alt_log_prob'] >= threshold)))].drop('chrm', axis=1)
	variants['allele'] = np.where((variants['alt_log_prob'] > variants['ref_log_prob'])
		, variants['alt_seq'], variants['ref_seq'])
	if save == True:
		fname = input('File name?\n')+".csv"
		variants.to_csv(fname, index=False)
		return None
	else:
		return variants
def mod_filtering():
	variants = variant_filtering(save=False)
	mods = pd.read_csv(f'{st_path}per_read_modified_base_calls.txt', delimiter= '\t')
	mods = mods.loc[(mods['chrm'] == 'KY962518.1_looped_2120')]
	mods['pos'] = np.where((mods['strand'] == '+'),
		mods['pos'], mods['pos']-1)

	mods['pos'] = np.where((mods['pos'] < 2120),
		mods['pos']-2120, mods['pos']-2120+1)
	mods = mods.loc[(mods['pos'] <= 16000) &
		((mods['mod_log_prob'] >= threshold) |
		(mods['can_log_prob'] >= threshold))].drop('chrm', axis=1)
	mods['methylation'] = np.where((mods['mod_log_prob'] > mods['can_log_prob']),'1', '0')
	#print(variants.head(2))
	#print(mods.head(2))
	compound_df = variants.merge(mods, how='inner', on=['read_id'], suffixes=['_SNP','_mod'])
	#print(compound_df.head())
	output_df = compound_df[['read_id','pos_SNP','allele','pos_mod','methylation']]
	#print(output_df.head())
	output_df.to_csv('haplotyping.csv', index=False)

if choice.lower() == 'v':
	variant_filtering()
elif choice.lower() == 'h':
	mod_filtering()
