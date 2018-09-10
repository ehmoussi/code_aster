! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine mdidisisot(sd_nl_, nbnoli, nomres, nbsauv, temps)
!
    implicit none
    character(len=*) :: sd_nl_
    integer          :: nbnoli
    character(len=8) :: nomres
    integer          :: nbsauv
    real(kind=8)     :: temps(*)
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvis.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/nlget.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
!
! --------------------------------------------------------------------------------------------------
!
!                       IMPRESSION DES RESULTATS SUR LES DIS_ECRO_TRAC
!
! --------------------------------------------------------------------------------------------------
!
! IN
!   sd_nl_  : nom de structure de données pour les calculs non linéaires
!   nomres  : nom du concept résultat
!   nbnoli  : nombre de liaison non-linéaire
!   nbsauv  : nombre de pas sauvegardé
!   temps   : instant de sauvegarde
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ific, nbocc, iocc, iret, ii
    integer :: nbvint, it, indx, jvint
    integer :: vv, nltype_i, start, jvindx, jdesc
    integer :: imprredir(7)
    character(len=8) :: noeud1, noeud2, sd_nl
!
    call jemarq()
    sd_nl = sd_nl_

    call getfac('IMPRESSION',  nbocc)
    if ( nbocc.eq.0 ) then
        goto 999
    endif

!   Récupération des variables internes
!   Longueur maximum d'un bloc de variables internes
    call jeveuo(nomres//'           .DESC', 'L', jdesc)
    nbvint  = zi(jdesc-1+4)
    if (nbvint.eq.0) goto 999
    call jeveuo(nomres//'        .NL.VINT', 'L', jvint)
    call jeveuo(nomres//'        .NL.VIND', 'L', jvindx)
!
!   Internal variables
!                    1 2 3       4 5 6  7      8         9 10 11  12 13 14
!       vari : force(x,y,z) depl(x,y,z) Dissip pcum deplp(x,y,z)  X(x,y,z)
!
    imprredir(1:7) = [1,4,2,5,3,6,7]
!
    do iocc = 1, nbocc
        call getvis('IMPRESSION', 'UNITE_DIS_ECRO_TRAC', iocc=iocc, scal=ific, nbret=iret)
        if ( iret.ne.1 ) cycle
!       Impression des informations sur les DIS_ECRO_TRAC
        if (.not. ulexis( ific )) then
            call ulopen(ific, ' ', ' ', 'NEW', 'O')
        endif
!
        do ii = 1 , nbnoli
            call nlget(sd_nl, _NL_TYPE, iocc=ii, iscal=nltype_i)
            if ( nltype_i.ne.NL_DIS_ECRO_TRAC ) cycle
            start  = zi(jvindx-1+ii) + 6
!           Noeuds du discret
            call nlget(sd_nl, _NO1_NAME, iocc=ii, kscal=noeud1)
            call nlget(sd_nl, _NO2_NAME, iocc=ii, kscal=noeud2)
            write(ific,100) '#'
            write(ific,100) '#--------------------------------------------------'
            write(ific,100) '#RESULTAT '//nomres
            write(ific,101) '#DIS_ECRO_TRAC ',ii,' '//noeud1//' '//noeud2
            write(ific,102) 'INST','FX','UX','FY','UY','FZ','UZ','PUISS'
            do it = 1 , nbsauv
                indx = jvint-1 +(it-1)*nbvint + start
                write(ific,103) temps(it), (zr(indx+imprredir(vv)-1),vv=1,7)
            enddo
        enddo
!       On ferme le fichier pour être sûr que le flush soit fait
        call ulopen(-ific, ' ', ' ', ' ', ' ')
    enddo
100 format(A)
101 format(A,I5,A)
102 format(8(1X,A18))
103 format(8(1X,1pE18.10E3))
!
999 continue
    call jedema()
end subroutine
