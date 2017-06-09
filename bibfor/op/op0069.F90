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

subroutine op0069()
use elim_lagr_data_module
    implicit none
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/crsolv.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/elg_calc_matk_red.h"
#include "asterfort/gcncon.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
! person_in_charge: jacques.pellet at edf.fr
!     OPERATEUR ELIM_LAGR
! ======================================================================
    character(len=19) :: matass, matred, krigi, krigred, solv1, solv2
    character(len=16) :: concep, nomcmd
    character(len=14) :: nu1, nu2
    character(len=8) :: k8bid
    character(len=3) :: kellag
    real(kind=8) :: r8bid
    integer ::  ifm, niv, jrefa, jslvk,  iautre, ibid
!   ------------------------------------------------------------------
    call jemarq()

    call infmaj()
    call infniv(ifm, niv)

    call getres(matred, concep, nomcmd)

!   -- matrice de rigidite :
    call getvid(' ', 'MATR_RIGI', scal=krigi)

!   -- autre matrice a reduire (masse, amortissement, ...):
    call getvid(' ', 'MATR_ASSE', scal=matass, nbret=iautre)


!   -- si 2 matrices partagent leurs relations lineaires
!      elles doivent aussi partager leur nume_ddl :
    if (iautre .eq. 1) then
        call dismoi('NOM_NUME_DDL', matass, 'MATR_ASSE', repk=nu1)
        call dismoi('NOM_NUME_DDL', krigi, 'MATR_ASSE', repk=nu2)
        ASSERT(nu1.eq.nu2)
        call jeveuo(krigi//'.REFA', 'L', jrefa)
        krigred=zk24(jrefa-1+19)(1:19)
        if (krigred .eq. ' ') call utmess('F', 'ELIMLAGR_11')
    else
        matass=krigi
    endif


!   -- 1. Reduction de la matrice :
!   ----------------------------------------

!   -- On recupere le solveur de matass (solv1)
    call dismoi('SOLVEUR', matass, 'MATR_ASSE', repk=solv1)
    if (solv1.eq.' ') then
!       -- on cree un solveur par defaut (qui sera surcharge dans CALC_MODES) :
        solv1='&&OP0069.SOLVEUR'
        call crsolv('MULT_FRONT', 'METIS', k8bid, r8bid, solv1, 'V')
    else
        ASSERT(.false.)
    endif

!   -- On modifie (temporairement) la valeur de ELIM_LAGR :
    call jeveuo(solv1//'.SLVK', 'E', jslvk)
    kellag=zk24(jslvk-1+13)(1:3)
    zk24(jslvk-1+13)='OUI'

!   -- Calcul de la matrice reduite (matred) :
    call elg_gest_data('NOTE', matass, matred, krigi)
    call elg_calc_matk_red(matass, solv1, matred, 'G')

!   -- On retablit la valeur de ELIM_LAGR :
    zk24(jslvk-1+13)=kellag

!   -- On fabrique un solveur pour la matrice reduite :
    call gcncon('_', solv2)
    call copisd('SOLVEUR', 'G', solv1, solv2)
    call jeveuo(solv2//'.SLVK', 'L', jslvk)
    zk24(jslvk-1+13)='NON'
    call jeveuo(matred//'.REFA', 'E', jrefa)
    zk24(jrefa-1+7)=solv2



!   -- 2. Si 2 matrices reduites partagent leurs relations lineaires
!         elles doivent aussi partager leur nume_ddl :
!   -----------------------------------------------------------------
    if (iautre .eq. 1) then
        call jeveuo(krigi//'.REFA', 'L', jrefa)
        krigred=zk24(jrefa-1+19)(1:19)
        call dismoi('NOM_NUME_DDL', krigred, 'MATR_ASSE', repk=nu2)

        call jeveuo(matred//'.REFA', 'E', jrefa)
        call detrsd('NUME_DDL', zk24(jrefa-1+2))
        zk24(jrefa-1+2)=nu2
    endif


    call jedema()
end subroutine
