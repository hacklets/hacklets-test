PATH=~/bin:$PATH

for f in ~/env/*.sh; do
   source "$f"
done

[ -f .bashrc ] && source .bashrc
