#!/usr/bin/env zsh

_zsh_terminal_set_256color() {
  if [[ "$TERM" =~ "-256color$" ]] ; then
    [[ -n "${ZSH_256COLOR_DEBUG}" ]] && echo "zsh-256color: 256 color terminal already set." >&2
    return
  fi

  local TERM256="${TERM}-256color"

  # Use (n-)curses binaries, if installed.
  if [[ -x "$( which toe )" ]] ; then
    if toe -a | egrep -q "^$TERM256" ; then
      _zsh_256color_debug "Found $TERM256 from (n-)curses binaries."
      export TERM="$TERM256"
      return
    fi
  fi

  # Search through termcap descriptions, if binaries are not installed.
  for termcaps in $TERMCAP "$HOME/.termcap" "/etc/termcap" "/etc/termcap.small" ; do
    if [[ -e "$termcaps" ]] && egrep -q "(^$TERM256|\|$TERM256)\|" "$termcaps" ; then
      _zsh_256color_debug "Found $TERM256 from $termcaps."
      export TERM="$TERM256"
      return
    fi
  done

  # Search through terminfo descriptions, if binaries are not installed.
  for terminfos in $TERMINFO "$HOME/.terminfo" "/etc/terminfo" "/lib/terminfo" "/usr/share/terminfo" ; do
    if [[ -e "$terminfos"/$TERM[1]/"$TERM256" || \
        -e "$terminfos"/"$TERM256" ]] ; then
      _zsh_256color_debug "Found $TERM256 from $terminfos."
      export TERM="$TERM256"
      return
    fi
  done
}

  # Set terminal to 256 color.
_colorize(){
  _zsh_terminal_set_256color
  unset -f _zsh_terminal_set_256color
}


  # Set terminal theme color
local ALIEN_THEME="white"
alien0(){
  if [[ $ALIEN_THEME == "red" ]]; then
    color0=088    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=202    # user bg
    color4=232    # user fg
    color5=214    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=226    # vcs fg
    color10=009   # battery discharging fg
    color11=028   # battery charging fg
    color12=019   # battery charged fg
  elif [[ $ALIEN_THEME == "green" ]]; then
    color0=022    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=034    # user bg
    color4=232    # user fg
    color5=082    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=154    # vcs fg
    color10=009   # battery discharging fg
    color11=028   # battery charging fg
    color12=019   # battery charged fg
  elif [[ $ALIEN_THEME == "blue" ]]; then
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
    color10=009   # battery discharging fg
    color11=028   # battery charging fg
    color12=019   # battery charged fg
  elif [[ $ALIEN_THEME == "white" ]]; then
    color0=236    # time bg
    color1=231    # init bg
    color1r=009   # init bg error
    color2=254    # time fg
    color3=241    # user bg
    color4=231    # user fg
    color5=231    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=238    # prompt fg
    color9=231    # vcs fg
    color10=009   # battery discharging fg
    color11=028   # battery charging fg
    color12=019   # battery charged fg
  else
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
    color10=009   # battery discharging fg
    color11=028   # battery charging fg
    color12=019   # battery charged fg
  fi


_is_svn(){
  if [[ $(svn info 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_svn_branch() {
  ref=$(svn info 2>/dev/null | grep Revision | awk '{print $2}') || return false;
  echo " SVN: @${ref} ";
  return true;
}

_is_git(){
  if [[ $(git branch 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return false;
  echo " GIT:  ${ref#refs/heads/} ";
  return true;
}

_is_hg(){
  if [[ $(hg branch 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_hg_branch() {
  ref=$(hg branch 2> /dev/null) || return true;
  echo " HG:  ${ref} ";
  return true;
}

_vcs_info(){
  if [[ $(_is_git) == 1 ]]; then
    _git_branch;
  elif [[ $(_is_hg) == 1 ]]; then
    _hg_branch;
  elif [[ $(_is_svn) == 1 ]]; then
    _svn_branch;
  else
    echo " ";
  fi
}

__storage_info(){
  fs=`df -h . | tail -1 | awk '{print $1}' | sed "s|\.|•|g" `;
  size=`df -h . | tail -1 | awk '{print $2}' | sed "s|\.|•|g" `;
  used=`df -h . | tail -1 | awk '{print $3}' | sed "s|\.|•|g" `;
  usedp=`df -h . | tail -1 | awk '{print $5}' | sed "s|\.|•|g" `;
  free=`df -h . | tail -1 | awk '{print $4}' | sed "s|\.|•|g" `;
  echo "💾 $fs - F:$free U:$used T:$size";
}
__date_time_info(){
  echo -n "`date +"%a %d %b %Y"`";
  echo -n " ⌚ ";
  echo -n "`date +%T`";

}

__ssh_client(){
  if [ -n "$SSH_CLIENT" ]; then
    echo $SSH_CLIENT | awk {'print $1 " "'};
  fi
}


__working_directory(){
  echo -n "${PWD/$HOME/~}"
}

__battery_stat(){
  __os=`uname`;
  if [[ $__os = "Linux" ]]; then
    if which upower > /dev/null ; then
      __bat_power=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}'`;
      __bat_power_ind="";
      # if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
      # elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
      # elif [[ $__bat_power = "fully-charged" ]]; then __bat_power_ind="•";
  # %K{color#} = background color
  # %F{color#} = foreground color
      if [[ $__bat_power = "charging" ]]; then __bat_power_ind="$color11";
      elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="$color10";
      elif [[ $__bat_power = "fully-charged" ]]; then __bat_power_ind="$color12";
      fi
      __bat_per=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed "s|%||g"`;
      if [[ -n $__bat_per ]]; then
      # echo " | ${__bat_power_ind}${__bat_per}";
        echo " %K{${__bat_power_ind}}%F{${color0}} %F{${color2}}${__bat_per} %K{${color0}}%F{${__bat_power_ind}}";
      fi
    fi
  fi
  if [[ $__os = "Darwin" ]]; then
    __bat_power=`pmset -g batt | tail -1 | awk '{print $4}' | tr -d "%;"`;
    __bat_power_ind="";
    # if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
    # elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
    # elif [[ $__bat_power = "finishing" ]]; then __bat_power_ind="+";
    # elif [[ $__bat_power = "charged" ]]; then __bat_power_ind="•";
    if [[ $__bat_power = "charging" ]]; then __bat_power_ind="$color11";
    elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="$color10";
    elif [[ $__bat_power = "finishing" ]]; then __bat_power_ind="$color11";
    elif [[ $__bat_power = "charged" ]]; then __bat_power_ind="$color12";
    fi
       __bat_per=`pmset -g batt | tail -1 | awk '{print $3}' | tr -d "%;"`
    if [[ -n $__bat_per ]]; then
      # echo " | ${__bat_power_ind}${__bat_per}";
      echo " %K{${__bat_power_ind}}%F{${color0}} %F{${color2}}${__bat_per} %K{${color0}}%F{${__bat_power_ind}}";
    fi
  fi
}


  RPROMPT=''
  _user=`whoami`
  setopt promptsubst
  PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user@$HOST %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} $(__working_directory) %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%F{$color7}%f
%F{$color9}%K{$color7}$(__ssh_client)%f%F{$color8}%k%B%b%f '
}



#%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user@$HOST %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} $(__working_directory) %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%F{$color7}%f
#%F{$color9}%K{$color7}$(__ssh_client)%f%F{$color8}%k%B%b%f 

alien_prompts(){
  alien0
}

_colorize()
autoload -U add-zsh-hook
alien_prompts


