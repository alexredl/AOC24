% Day 24 of AOC2024
fprintf('Day 24 of AOC2024\n');
% Part 1
fprintf('Part 1\n');

% wire dictionary
wires_dict_orig = containers.Map('KeyType', 'char', 'ValueType', 'double');
conns_dict_orig = containers.Map('KeyType', 'char', 'ValueType', 'any');

% read file
is_wires = true;
file = fopen('input.txt', 'r');
while ~feof(file)
    line = fgetl(file);
    if isempty(line)
        is_wires = false;
        continue;
    end
    
    if is_wires
        parts = split(line, ': ');
        key = char(parts(1));
        val = str2double(parts(2));
        wires_dict_orig(key) = val;
    else
        parts = split(line, ' -> ');
        key = char(parts(2));
        val_parts = split(parts(1));
        conns_dict_orig(key) = {char(val_parts{1}), char(val_parts{3}), char(val_parts{2})};
    end
    
    %fprintf('%d, %s\n', is_wires, line);
end

% clean wires and connection dictionaries
wires_dict = copyDict(wires_dict_orig);
conns_dict = copyDict(conns_dict_orig);

% print wires dictionary
%printWiresDict(wires_dict);

% print connection dictionary
%printConnsDict(conns_dict);

% fill the wires dictionary
fillWiresDict(wires_dict, conns_dict);

% get outout of z** wires
fprintf('Decimal number is %d\n', getDecimal(wires_dict));

% Part 2
fprintf('Part 2\n');

% get original x, y and expected z decimals
x_num = getDecimal(wires_dict_orig, 'x');
y_num = getDecimal(wires_dict_orig, 'y');
z_num_exp = x_num + y_num;
%fprintf('Original x=%d, y=%d -> z_exp=%d\n', x_num, y_num, z_num_exp);

% clean wires and connection dictionaries
wires_dict = copyDict(wires_dict_orig);
conns_dict = copyDict(conns_dict_orig);

% get max z value
max_z = getMaxZ(conns_dict);
%fprintf('maxZ = %d\n', max_z);

% check for wrong instructions
failures = {};
key_list = keys(conns_dict);
for i = 1:length(key_list)
    key = key_list{i};
    vals = conns_dict(key);
    
    % if operation is 'AND' then super-operation must be 'OR' (except for
    % x00 and y00)
    if strcmp(vals{3}, 'AND') && ~(strcmp(vals{1}, 'x00') || strcmp(vals{1}, 'y00'))
        for j = 1:length(key_list)
            vals_sup = conns_dict(key_list{j});
            if (strcmp(vals_sup{1}, key) || strcmp(vals_sup{2}, key)) && ~strcmp(vals_sup{3}, 'OR')
                if ~ismember(key, failures), failures{end + 1} = key; end
            end
        end
    end
    
    % if result is 'z**' (excluding hightest z), operand must be 'XOR'
    if startsWith(key, 'z') && str2double(key(2:end)) ~= max_z
        if ~strcmp(vals{3}, 'XOR')
            if ~ismember(key, failures), failures{end + 1} = key; end
        end
    end
    
    % if operation is 'XOR'
    if strcmp(vals{3}, 'XOR')
        for j = 1:length(key_list)
            vals_sup = conns_dict(key_list{j});
            if (strcmp(vals_sup{1}, key) || strcmp(vals_sup{2}, key)) && strcmp(vals_sup{3}, 'OR')
                 if ~ismember(key, failures), failures{end + 1} = key; end
            end
        end
                
        % if one operand is 'x**' it cannot be assigned to 'z**' and 
        % super-operation must be 'XOR'
        if (startsWith(vals{1}, 'x') && str2double(vals{1}(2:end)) ~= 0) || (startsWith(vals{2}, 'x') && str2double(vals{2}(2:end)) ~= 0)
            if startsWith(key, 'z')
                if ~ismember(key, failures), failures{end + 1} = key; end
            end
            
        % if neither operand is 'x**', it must be assigned to 'z**'
        else
            if ~startsWith(key, 'z')
                if ~ismember(key, failures), failures{end + 1} = key; end
            end
        end
    end
end

% get failure list
failures_str = strjoin(failures, ',');
fprintf('Failures are: %s\n', failures_str);

% try switching them around
for i1 = 1:length(failures)
for i2 = i1+1:length(failures)
    for j1 = i1+1:length(failures)
    if j1 == i2, continue; end
    for j2 = j1+1:length(failures)
    if j2 == i2, continue; end
        for k1 = j1+1:length(failures)
        if k1 == j2 || k1 == i2, continue; end
        for k2 = k1+1:length(failures)
        if k2 == j2 || k2 == i2, continue; end
            for l1 = k1+1:length(failures)
            if l1 == k2 || l1 == j2 || l1 == i2, continue; end
            for l2 = l1+1:length(failures)
            if l2 == k2 || l2 == j2 || l2 == i2, continue; end
                %fprintf('Swapping: i(%d, %d), j(%d, %d), k(%d, %d), l(%d, %d)\n', i1, i2, j1, j2, k1, k2, l1, l2);
                
                % clean wires and connection dictionaries
                wires_dict = copyDict(wires_dict_orig);
                conns_dict = copyDict(conns_dict_orig);
                
                % flip entries in connection dictionary
                tmp = conns_dict(failures{i1});
                conns_dict(failures{i1}) = conns_dict(failures{i2});
                conns_dict(failures{i2}) = tmp;
                
                tmp = conns_dict(failures{j1});
                conns_dict(failures{j1}) = conns_dict(failures{j2});
                conns_dict(failures{j2}) = tmp;
                
                tmp = conns_dict(failures{k1});
                conns_dict(failures{k1}) = conns_dict(failures{k2});
                conns_dict(failures{k2}) = tmp;
                
                tmp = conns_dict(failures{l1});
                conns_dict(failures{l1}) = conns_dict(failures{l2});
                conns_dict(failures{l2}) = tmp;
                
                % fill the wires dictionary
                fillWiresDict(wires_dict, conns_dict);

                % get outout of 'z**' wires
                z_num = getDecimal(wires_dict);
                
                % found solution
                if z_num == z_num_exp
                    fprintf('Possible swap:\n (%s <-> %s)\n (%s <-> %s)\n (%s <-> %s)\n (%s <-> %s)\n', failures{i1}, failures{i2}, failures{j1}, failures{j2}, failures{k1}, failures{k2}, failures{l1}, failures{l2});
                end
            end
            end
        end
        end
    end
    end
end
end


% function for printing the wires dictionary
function printWiresDict(wires_dict)
    fprintf('Wires dictionary:\n')
    keys_list = keys(wires_dict);
    for i = 1:length(keys_list)
        key = keys_list{i};
        val = wires_dict(key);
        fprintf('Key: %s, Value: %d\n', key, val);
    end
end

% function for printing connections dictionary
function printConnsDict(conns_dict)
    fprintf('Connections dictionary:\n')
    keys_list = keys(conns_dict);
    for i = 1:length(keys_list)
        key = keys_list{i};
        val = conns_dict(key);
        fprintf('Key: %s, Value: %s(%s, %s)\n', key, val{3}, val{1}, val{2});
    end
end

% function for filling wires dictionary with connections dictionary
function fillWiresDict(wires_dict, conns_dict)
    conns_keys = keys(conns_dict);
    while ~isempty(conns_keys)
        prev_len = length(conns_keys);
        for i = 1:length(conns_keys)
            conns_key = conns_keys{i};
            conns_vals = conns_dict(conns_key);
            % check if needed conns_vals are in wires_dict already
            %fprintf('Check if %s and %s is in wires_dict\n', conns_vals{1}, conns_vals{2})
            if isKey(wires_dict, conns_vals{1}) && isKey(wires_dict, conns_vals{2})
                remove(conns_dict, conns_key);

                % do operation
                if strcmp(conns_vals{3}, 'AND')
                    if wires_dict(conns_vals{1}) == 1 && wires_dict(conns_vals{2}) == 1
                       wires_dict(conns_key) = 1;
                    else
                        wires_dict(conns_key) = 0;
                    end

                elseif strcmp(conns_vals{3}, 'OR')
                    if wires_dict(conns_vals{1}) == 1 || wires_dict(conns_vals{2}) == 1
                       wires_dict(conns_key) = 1;
                    else
                        wires_dict(conns_key) = 0;
                    end

                elseif strcmp(conns_vals{3}, 'XOR')
                    if wires_dict(conns_vals{1}) ~= wires_dict(conns_vals{2})
                       wires_dict(conns_key) = 1;
                    else
                        wires_dict(conns_key) = 0;
                    end

                else
                    fprintf('ERROR: Operation %s not defined!\n', conns_vals{3});
                    break
                end
            end
        end
        conns_keys = keys(conns_dict);
        if length(conns_keys) == prev_len
            fprintf('ERROR: Did not find any more wires, but conns_dict is not empty!\n');
            break 
        end
    end
end

% get decimal number from (default) z** of wires dictionary
function decimal = getDecimal(wires_dict, letter)
    if nargin < 2
       letter = 'z';
    end
    binary = '';
    keys_list = keys(wires_dict);
    for i = length(keys_list):-1:1
        key = keys_list{i};
        if startsWith(key, letter)
            val = wires_dict(key);
            binary = binary + string(val);
        end
    end
    
    % return decimal value
    decimal = bin2dec(binary);
end

% function for copying a dictionary
function copied_dict = copyDict(source_dict)
    copied_dict = containers.Map('KeyType', source_dict.KeyType, 'ValueType', source_dict.ValueType);
    keys_list = keys(source_dict);
    for i = 1:length(keys_list)
        key = keys_list{i};
        value = source_dict(key);
        copied_dict(key) = value;
    end
end

% get max z
function max_z = getMaxZ(conns_dict)
    keys_list = keys(conns_dict);
    max_r = 0;
    for i = 1:length(keys_list)
        key = keys_list{i};
        if startsWith(key, 'z')
            max_r = max(str2double(key(2:end)), max_r);
        end
    end
    
    % return maximal z value
    max_z = max_r;
end