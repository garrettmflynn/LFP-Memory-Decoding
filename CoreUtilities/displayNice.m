function [] =  displayNice(current, final, verbiage)
    if current>1
          fprintf('\b\b\b')
          for j=0:log10(current-1)
              fprintf('\b'); % delete previous counter display
          end    
          fprintf([num2str(current) '/' num2str(final)]);
    else
    fprintf([verbiage, ' ', num2str(current) '/' num2str(final)]);
    end
    
    if current == final
        fprintf('\n');
    end
end