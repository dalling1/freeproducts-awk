BEGIN{
 ### set up three graphs to use
 ### (these are sometimes referred to as the "protographs")
 H[1] = "1--2;2--3;"; # three nodes in row
 H[2] = "a--b;b--c;c--a;c--d;"; # triangle with extra edge attachd
# H[3] = "p--q;q--r;r--s;"; # four nodes in a row

 ### define the node labels
 N[1][1] = "1";
 N[1][2] = "2";
 N[1][3] = "3";
 N[1][4] = "4";

 N[2][1] = "a";
 N[2][2] = "b";
 N[2][3] = "c";
 N[2][4] = "d";

 N[3][1] = "p";
 N[3][2] = "q";
 N[3][3] = "r";
 N[3][4] = "s";

 ### initialise the free product graph
 G = "";
 rootnode = "0";
 isdone[rootnode] = 0; # flag for which nodes have had all children attached

 ### set the update function for initial node
 ### (the update function specifies the nodes at which protographs are connected)
 U[rootnode][1] = "1";
 U[rootnode][2] = "a";
 U[rootnode][3] = "p";

 I[1]=1;
}

{
 ### use the input to define the depth of the free product graph
 Lmax = $1;

 ### loop over the levels and attach protographs as required
 for (L=1;L<=Lmax;L++){
  if (L==1){
   thisnode = rootnode;
  } else {
   # find the first not done node
   for (key in isdone){
    if (!isdone[key]){
     thisnode=key;
    }
   }

  }
  if (!isdone[thisnode]){
   for (n=1;n<=length(H);n++){
    # add H(n) to the graph but replace U[thisnode](n) with thisnode:
    Hnew = H[n];
    gsub(U[thisnode][n],thisnode,Hnew);
    # now append the "level" of these added graphs to their labels
    for (i=1;i<=length(N[n]);i++){
     gsub(N[n][i],N[n][i] L,Hnew);
    }
    # except for the root node
    gsub("00","0",Hnew);

    G = G Hnew; # add the edited copy of H(n) to the overall graph G
    for (i=1;i<=length(N[n]);i++){
     if (N[n][i] != U[thisnode][n]){ # this was a new node added to G
      newnode = N[n][i];
      I[length(I)+1] = length(I)+1;
      isdone[newnode] = 0;
      for (m=1;m<=length(H);m++){ # next we will set all of the entries in U
       if (m!=n){ # duplicate the mth update function of the "parent"
         U[newnode][m] = U[thisnode][m];
       } else { # otherwise, we modify the update function
        U[newnode][n] = newnode;
       }
      }
     }
    }
   }
   isdone[thisnode] = 1;
  }
 }
}

END {
 ### output the free product graph in a format for pasting into viz-js.com
 gsub(";",";\n ",G);
 print "graph {\n";
 for (n=1;n<=length(H);n++){
  print " " H[n];
 }
 print "\n " G;
 for (key in isdone){
  ### label nodes with their update function
  print(" " key L-1 "[label = \"" U[key][1] "," U[key][2] "," U[key][3] "\" style=filled fillcolor=yellow];");
 }
 print "\n}";
}
