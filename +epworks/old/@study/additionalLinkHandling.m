function additionalLinkHandling(obj)
%
%
%
%   epworks.study.additionalLinkHandling

%TODO: These should be helper functions ...

   return

   %Relate groups to sets ...
   %------------------------------------------------------
   g = obj.groups;
   n_groups = length(g);
   for iGroup = 1:n_groups
       cur_g = g(iGroup);
       b_set = cur_g.baseline_set;
       if isobject(b_set)
          b_set.is_baseline_set = true;
          %b_set.baseline_set_group_ref = cur_g;
       end
       r_sweep = cur_g.raw_sweep_set_id;
       if isobject(r_sweep)
          r_sweep.is_raw_sweep_id = true;
          %r_sweep.raw_sweep_group_ref = cur_g;
       end
   end

   sets = obj.sets;
   [is_baseline_mask]  = [sets.is_baseline_set];
   [is_raw_sweep_mask] = [sets.is_raw_sweep_id];
   
   obj.group_baseline_sets  = sets(is_baseline_mask);
   obj.group_raw_sweep_sets = sets(is_raw_sweep_mask);
   
   delete_mask = is_baseline_mask | is_raw_sweep_mask;
   
   obj.sets(delete_mask) = [];
   sets(delete_mask) = [];
   
   %Here we link the groups to the normal sets. Currently
   %only the baseline and raw_sweep sets are linked ...
   %-----------------------------------------------------------------------
   group_ids_local    = vertcat(g.self_id);
   groups_from_set    = [obj.sets.parent];
   group_ids_from_set = vertcat(groups_from_set.self_id);
   
   %This could be improved instead of doing the search
   %in the loop
   [~,loc] = ismember(group_ids_from_set,group_ids_local,'rows');
   
   for iGroup = 1:n_groups
      g(iGroup).normal_sets = sets(loc == iGroup);
   end
   
end