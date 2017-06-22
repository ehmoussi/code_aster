! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine lectit(ifl, icl, iv, rv, cv,&
                  cnl, mcl, nbm, nbg, dim,&
                  nbt, irteti)
    implicit none
!       PREMIERE LECTURE DES DONNEES POUR  UN MOT CLE DE TYPE TITRE
!       ----------------------------------------------------------------
!       IN      IFL,ICL,IV,RV,CV,CNL =  VOIR LIRITM
!               MCL             = MOTS CLES TYPE TITRE
!               NBG             = NIVEAU DEBUG
!               NBM             = NB DE MOTS CLES TYPE TITRE
!                               = 1 > ERREUR EN LECTURE
!               DIM             = DIMENSION  OBJET TITRE(NB LIGNES)
!               NBT             = NB TOTAL DE LIGNES LUES(ICI NBT=DIM)
!               (RETURN)        = MOT CLE SUIVANT (MOT CLE NON RECONNU)
!               (RETURN 1)      = EXIT            (MOT CLE FIN TROUVE)
!               (RETURN 2)      = LIGNE SUIVANTE  (MOT CLE FINSF TROUVE)
!       ----------------------------------------------------------------
!
#include "asterfort/iunifi.h"
#include "asterfort/lirlig.h"
#include "asterfort/lxscan.h"
#include "asterfort/tesfin.h"
#include "asterfort/tesmcl.h"
    integer :: nbm
    real(kind=8) :: rv
    character(len=8) :: mcl(nbm)
    integer :: dim(nbm), nbt(nbm)
    character(len=14) :: cnl
    character(len=*) :: cv
    character(len=80) :: lig
!-----------------------------------------------------------------------
    integer :: icl, ideb, ifl, ifm, irtet, irteti
    integer :: iv, nbg
!-----------------------------------------------------------------------
    irteti = 0
!
    ifm = iunifi('MESSAGE')
!
! - ITEM = MOT CLE  TITRE  ?
!
    call tesmcl(icl, iv, cv, mcl(1), irtet)
    if (irtet .eq. 1) goto 3
    if (nbg .ge. 1) write(ifm,*)' ----- LECTIT'
!
! - LIRE LIGNE SUIVANTE
!
  4 continue
    call lirlig(ifl, cnl, lig, 1)
!
    if (nbg .ge. 1) write(ifm,*)'       LIRLIG :',cnl,lig
!
! - LIRE PREMIER ITEM DE LA LIGNE
!
    ideb = 1
    call lxscan(lig, ideb, icl, iv, rv,&
                cv)
!
    if (nbg .ge. 1) write(ifm, *)'       LXSCAN : ICL = ', icl, ' IV = ', iv, ' RV = ', rv,&
                    ' CV(1:8) = ', cv(1:8), ' IDEB = ', ideb
!
!
! - ITEM = MOT  CLE FIN  OU FINSF ?
!
    call tesfin(icl, iv, cv, irtet)
    if (irtet .eq. 1) then
        goto 1
    else if (irtet .eq. 2) then
        goto 2
    endif
    dim(1) = dim(1) + 1
    nbt(1) = nbt(1) + 1
!
    goto 4
!
  1 continue
    irteti = 1
    goto 999
  2 continue
    irteti = 2
    goto 999
  3 continue
    irteti = 0
    goto 999
!
999 continue
end subroutine
