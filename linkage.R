library(tidyverse) 

variants_all <- read_csv('mandinka_test.csv', col_types = cols()) %>%
  select(read_id, pos, allele) %>%
  distinct() %>%
  group_by(pos) %>%
  filter(n_distinct(allele) > 1) %>%
  mutate(allele_num=dense_rank(allele)) %>%
  ungroup()
  
cols <- c("1_1"=0, "1_2"=0, "1_3"=0,
          "2_1"=0, "2_2"=0, "2_3"=0,
          "3_1"=0, "3_2"=0, "3_3"=0)
linkage_all <- variants_all %>%
    inner_join(variants_all,
             by=c('read_id'),
             suffix=c('_1', '_2')) %>%
  filter(pos_1 < pos_2)%>%
  group_by(pos_1, allele_num_1,
           pos_2, allele_num_2) %>%
  summarise(num_reads=n_distinct(read_id), .groups='drop') %>%
  mutate(haplotype=paste(allele_num_1, allele_num_2, sep='_')) %>%
  pivot_wider(-c(allele_num_1, allele_num_2),
              names_from='haplotype',
              values_from='num_reads',
              values_fill=0) %>%
  add_column(!!!cols[!names(cols) %in% names(.)]) %>%
  rowwise() %>%
  mutate(
    broom::tidy(
      fisher.test(
        matrix(c(`1_1`, `1_2`, `1_3`,
                 `2_1`, `2_2`, `2_3`,
                 `3_1`, `3_2`, `3_3`),
           byrow=T, nrow=3)))) %>%
  ungroup()
