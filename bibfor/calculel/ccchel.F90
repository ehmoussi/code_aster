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

subroutine ccchel(option, modele, resuin, resuou, numord,&
                  nordm1, mateco, carael, typesd, ligrel,&
                  exipou, exitim, lischa, nbchre, ioccur,&
                  suropt, basopt, resout)
    implicit none
!     --- ARGUMENTS ---
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/ccaccl.h"
#include "asterfort/cclpci.h"
#include "asterfort/cclpco.h"
#include "asterfort/ccpara.h"
#include "asterfort/ccpoux.h"
#include "asterfort/detrsd.h"
#include "asterfort/meceuc.h"
    aster_logical :: exipou, exitim
    integer :: nbchre, ioccur, numord, nordm1
    character(len=1) :: basopt
    character(len=8) :: modele, resuin, resuou, carael
    character(len=16) :: option, typesd
    character(len=19) :: lischa
    character(len=24) :: mateco, ligrel, resout, suropt
!  CALC_CHAMP - CALCUL D'UN CHAMP ELNO ET ELGA
!  -    -                   --    --
! ----------------------------------------------------------------------
!
!  ROUTINE DE CALCUL D'UN CHAMP DE CALC_CHAMP
!
! IN  :
!   OPTION  K16  NOM DE L'OPTION
!   MODELE  K8   NOM DU MODELE
!   RESUIN  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT IN
!   RESUOU  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT OUT
!   NUMORD  I    NUMERO D'ORDRE COURANT
!   NORDM1  I    NUMERO D'ORDRE PRECEDENT
!   MATECO  K8   NOM DU MATERIAU CODE
!   CARAEL  K8   NOM DU CARAELE
!   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
!   LIGREL  K24  NOM DU LIGREL
!   EXIPOU  BOOL EXISTENCE OU NON DE POUTRES POUX
!   EXITIM  BOOL EXISTENCE OU NON DE L'INSTANT DANS LA SD RESULTAT
!   LISCHA  K19  NOM DE L'OBJET JEVEUX CONTENANT LES CHARGES
!   NBCHRE  I    NOMBRE DE CHARGES REPARTIES (POUTRES)
!   IOCCUR  I    NUMERO D'OCCURENCE OU SE TROUVE LE CHARGE REPARTIE
!   SUROPT  K24
!   BASOPT  K1   BASE SUR LAQUELLE DOIT ETRE CREE LE CHAMP DE SORTIE
!
! OUT :
!   RESOUT  K24  NOM DU CHAMP OUT
! ----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
!
    integer :: iret, nbpaou, nbpain
!
    character(len=8) :: poux, lipain(100), lipaou(1)
    character(len=24) :: lichin(100), lichou(2)
!
    resout = ' '
!
    if (exipou) then
        poux = 'OUI'
    else
        poux = 'NON'
    endif
!
    call ccpara(option, modele, resuin, resuou, numord,&
                nordm1, exitim, mateco(1:8), carael)
!
    call cclpci(option, modele, resuin, resuou, mateco(1:8),&
                carael, ligrel, numord, nbpain, lipain,&
                lichin, iret)
!
    if (iret .ne. 0) then
        goto 999
    endif
!
    call cclpco(option, resuou, numord, nbpaou, lipaou,&
                lichou)
!
!     A PARTIR D'ICI, ON TRAITE LES CAS PARTICULIERS
    if (exipou) then
        call ccpoux(resuin, typesd, numord, nbchre, ioccur,&
                    lischa, modele, nbpain, lipain, lichin,&
                    suropt, iret)
        if (iret .ne. 0) then
            goto 999
        endif
    endif
!
    call ccaccl(option, modele, mateco(1:8), carael, ligrel,&
                typesd, nbpain, lipain, lichin, lichou,&
                iret)
    if (iret .ne. 0) then
        goto 999
    endif
!     FIN DES CAS PARTICULIERS
!
    call meceuc('C', poux, option, carael, ligrel,&
                nbpain, lichin, lipain, nbpaou, lichou,&
                lipaou, basopt)
!
    resout = lichou(1)
!
    call detrsd('CHAM_ELEM', '&&CALCOP.INT_0')
!
999 continue
!
end subroutine
