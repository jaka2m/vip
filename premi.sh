#!/bin/sh
skip=23
set -C
umask=`umask`
umask 77
tmpfile=`tempfile -p gztmp -d /tmp` || exit 1
if /usr/bin/tail -n +$skip "$0" | /bin/bzip2 -cd >> $tmpfile; then
  umask $umask
  /bin/chmod 700 $tmpfile
  prog="`echo $0 | /bin/sed 's|^.*/||'`"
  if /bin/ln -T $tmpfile "/tmp/$prog" 2>/dev/null; then
    trap '/bin/rm -f $tmpfile "/tmp/$prog"; exit $res' 0
    (/bin/sleep 5; /bin/rm -f $tmpfile "/tmp/$prog") 2>/dev/null &
    /tmp/"$prog" ${1+"$@"}; res=$?
  else
    trap '/bin/rm -f $tmpfile; exit $res' 0
    (/bin/sleep 5; /bin/rm -f $tmpfile) 2>/dev/null &
    $tmpfile ${1+"$@"}; res=$?
  fi
else
  echo Cannot decompress $0; exit 1
fi; exit $res
BZh91AY&SY�>�� t����I������������RD@�   @ `3��{���5������}�]�����
�����K�
��۾�M}��[j+�|�相
)ٚ�h��6գmY�>�u�+kH6������De�v�u�����v�v����ˤm�Z�;i�b�$���Ё��I�M��ƚ���?*~F�j�jb�)�I���<� z����� Bi0�A4"��Ry�OS�=&)��A��4PP��A�@ M4$4�)�)�4��h    4=@    $ԈE<jbe6��5��=��='����z� �� ��h �Dh��Oi�Oƍ��IOd�OjL�Q�m@��i�ɧ�=@��$D@C@ 	��=	��2M'�M������C ��h= d���P$$�"0^�i
�B�&@����!G��?����v��i������������DDĴ�|����@o� N0E�,vJ��wv��ͬ�ĭ�ò�7݃�� f�'��{.3Y�A
,r�>�(Jb�v��X������gެ��#�l���ݛ��ry�0�
������`)�	�9�S�r`C	s�a{��@_J^\aJ:��-�T�}���	���1�����pg/^0t��씻\���c��%�Tz��0uQ�hSѝ%�$	��+��N�C$�n�fІb�HO�����nV�䳫I�4��#�KT0��OFw�kkJ��G�M���ġݻ����x��|K
�YTu��Bұss�i�ϑb��N�X���i-
 ���-���O�X�΢��������E��|��`�E�2$k���J�d��\1�c�_��S3_�C�A��CNsƄu
�v�G�8�}�]J͊�;�ϸ��b����L���p;�rM��Fz�E�1̚��,�'��@�H�r�su�Ǚ��9�q��F�p�00&�HD��}�e�̗=ҫd��(^=Ǿ�G$�"� i���������Imr(�Xd�M�Z�v�mѳ��]x��ʲ2�����u9��,�m��Zv⎦i[����0��ŰkZ��rP+rS*^���Mno:-�<�ｎ���ZRf@���<@7�C�����Dq�{%B��ܵP���C��?��� *ВK^Җ���?%�������-���H`�ni	OK0��x|6P�k��]-�vYwa���	T82����! �
�Z������ֿ�+�t�C^��c��L��?p�M�6����5�2�ߌ�Z����V�?�e[�N?��-�U	����:"�E��a��VR�Ol �ei������/�An4JL����ڍ�>�	�:���J2�����j)�s��+<���^�4 �����Y��&"�Ǌӻ��YY�jq���1J��W���;�h?��Lڙ���� !N�Z���Sʆ���J�=,�h�8��`�R@bN�X��ӿ�}ޞ��fϟ`t�MI:?H�:|�i�����׽B�c�N�)8�th�`/��uo l�O��dd�Z�ȅ �#3Y#M{2�c|D;�^��}���k�����0:�sϗ!�$'�Pu�/4��c��`/��6�0��@�ƭ
��vE� Y��N�g�?�m�.�W	�}r^i�|�P�����D��=8|�GXjԀ"U��<�xT�� \e��,4]����e�FP$�����+~�,�6K�I׆�)��Pc�҃8˃^<��N��h7B��߯�
HAR���M��na,h��)E.�J�6���bQ��@��a �k�X�Zj��;,�&��ɔ���`ؘ���l�$�$hD."^�VfLa�pg�G?�^j���]���������!^�C3����ž-��@E�Yp�v�I�U�G��;�����p�Ϣ=98�\o�XD$���క�c�| ��� }�����!��]�6�H��I�+z��?�>�f�/#�ګ�Z��	LV�j��Y����M)�a
!p��n*�-�������w���6~�^����iK����VKu��m�3�6���#a�أ�{��$n7x�l�����d��/Fr�c�6!�<�z�P��ǕXF�W�	 S��|�BW�'\C�yŴ�4���]$G0;��h�1�fC�`�m�y��µ�pԂN)��y�s�-C����-a�i�b��axڌa��`�$[~wԃb��ǁ�I��9�Z��`h������E��fl�u����	MC�B� -�������AD�$3���
���3B��KH�3e����nU�Vj�B��}c�����A�c��PA�p>|�%��}�Q��k�Y;{�@�����F�M�|"ׁ��A�"�U����m�j�@B����6�ՋC��9Ꮰ ���u��ďL���m���� ���$ͨ)I��rt�G�w��Ţ�_rr�8�2����8��85@f瑅����ҳj�]>���a�������済֜,Ь�v�#��(�T�Y Dp�fj��le�D�iZSRk6�"�f��G3�j)���DQ���U��V�31߻ϫf}��e��c:,���:�灳�i1J0�yizl۶T�WL<vp�J a��8�D���.V! ��vړ�������59�;��`Wf�I��j���"�7K�R��&�Ӵƃ?X�=��*HbW��G)4gi��U�9�
��u��ut�P2Ύ�{�J��R��`��C	�s"7��GN��O�lT'��$s1�L�@�nS��f0D1p� 
fRc���\�blJݘw7���\��9�)M,SqC6���>#�	D
�:���-T̽����\ϣ�����J��{~^E	���/��H���?�BT*P��7���y�� 0�C�Q<�4����Jd)��-�K��1J ��O�w���������vjT.�aUP)��,�{	J��by�s`�jlʩA�н��`Q��P�6����,�YL��%��	2K!d�S:�If�Ӫ s���*�_�=��L���W�O-�����}��Ң{![7S�O��Z��Ţ��gr#ET��.B�H'��{���.� p��^����W��q���f���aI�9��#�{��4���[X%�DB�N�_�>O;�8Nݔ�t�� ?ˈ��.�C��r!��'���x|�J��d\,�\|�$��Oe~�h\��_�ΈdgL���R	�s���X�(愆���稔����LΚ�!:�wZ~�-^X�fA'�1����늦~jDr�C���K	Z\B���_���G�~c��6�M�g�`���!#��l�:ߞ�Bp?h���R�E ��o6@p�u"O}��#��j �(�Q�X{�;�r�2�O�.��37S�{�� HX�`#�$z#2JZ�y�l�\2���7����f.Ή��-A�D5H���i7��6��v#.\k��Y�Eo��iQK�H��M��x6�<�-����!$�3v|���v��uK�`�Q}L}�Mg�=4F�������@r�GB�]R��h��ɣ�TeI��Qf ��^IViI3��T�xY�G��s��V�"U�ǼJ��A���ъ�L���D.$}OۏD���F�fl3�
�M�s����ȿ>8 �QZ�+3���6+�9"�p�
e��.�����3h?��A6�˸��z,�����z�@�h����N��} D��4T�:�H<3@�}.bDG��|�Gͼ]=�T^m"���ɟtA��"�ޛ8�w�ff&�G��&�ǜ�[�.�0W��he�燑AV,����k9C�5�5i�A�Є��!%�*��F)�,X�H�(̶C7�o_j��'�ȺaH4-^��k�F�I�� ��>*��~����[@��-3e<�A�I����P]4UV��r!�.a� �-��BKU�3�ح�6ce�v�)�,ک(V�P8�mf�` �%��zX��Î{:T��Ŋ.|;Cx``4mh�%��8lD�c�3\Լ�D����5Vڥt�M9ĴJ@�E�/{��BJՂ͜8��?m�V��-������ZM�3y	*��٣0̈��L��g/�O|a��y�x\2�{�S������<%�f-MYԐbZkL?$�?ϯ��ԓ�M*���r'�W5w�z��F�G���8��S���lg�T���$�Haz��dYL��@-�}r핢aHh�@[ ���-�����S��R����1bIz�NG�@2ƏI�׫8]�i �X���KM��Y��2�D�u̬�-+"���S�{7RJU3nu�zAC$�5=WGM��_t�e�m�5�Kkɼ�L���s{5`�\0n(�O<WbF�Zȯj#b5 �7�B��cv4l��KrT��яQ��t_�b.����g�@�p5$��6�|�``���� �NT��Fgqq�z�~��۔�R8�u�<��_Or{�+��}z����!w�ESE��©��q���n�����J�}WG�҃��*�˪y���g�#r�TSނ�R��Ճlw��͏�5�W��'���G��i�3®�K�)��4p�ޭVQ���$�"<��m�%�.쨺f��'F��OL��k��TX)bD�*��O�rC�LUA� ��0�� "������w �A�vs���Z�C������z���>���(yM<���f�>��U�Pz���0+��由c[���7��J�d�e�=�C�m*�<�@ߜg�����+�Nn������k��x{XPzD�췹!��A�p҆塘T����MA�x���+���H��Å�Vz���F�R�;�g#��j} ���x�y떳��YKz���B�v����=��(�����?e��yx~з�� ϻT08��0t�Q�SN��{~���_ ��ה�.�"�\i����\�'�����3߶^�:GM��A����I"������[ޓ7��J�������Pr��^v/�Y�h]����i�R�%Wy�����������T��A�C����~�(٧˺mW؍�ls���w֥L��n��iT�=٘8��˃�k��_ÝZN�#������*�Wl5ǫzv6ԄX�]=C�Y��4CGH#-�s�HR.=KBV*�8=��V�VcAcH�i��FvzXj�����Jm����by�Y-�Q����=z,q�KF�:-��I;�i�AE�4u�Yy$tl�Qhp��_�Z���H�\�H��R�YGy�e�]�|e�2����B��ryWq��p�����-7Go혞c�7T��8E{�;��y�S�:`�f~)+�觚m$�ފ�ǡ��e�@��~R�w���^�ǰ��J6�ԑ��ۻ��,�l��9E4��\v��<Dހ�4�"1c��X�߁�*h�2������T�����[�����\n��FcZ��e���|*�L�Ќt 6���~��e�Os��D3V�Ǝ_%�ߪyq�3P�Tjm5f�\������g�G���na�ԇiʥ��B� ?ګ��T��l�R�80�L`��<��rpX��d+S��R"0#x۴��/��
�\�<i���ı���s���9B�Xss��4��5M�}���P�|ݓ��� �!! ����h�����L�=k�|��������T󄘁�Ȥ���&��-����{;�3���8�r�T��!?�,3���Ƈ��+qy3C���j�X^T��(VRC#����R3���s	5w~��D0�Y��r~?�
��ڈ�ع 6e���d��l@UPy҆�����c��x�p>r��{�pT����
�i�b�[��G6��;Y;���C��Nʐ%��zg���?���lM*�G���|�$_�Ys�:F��X�!m��ů�]\F�9�E��-b���4Pm�ꎚYB(�(dIUD0�}6�7���ia��a���O���:5���e4L�~�G��~��|l�Vqi(P+�TӴ��^��<�H=A�dgE�	����raя-�pG��Hq�h0a�41�s<������	���HK����I ���0]M.+R�ҕH�Ab�11�EZ��la�KO.[ �,����hbmN�@�m+۪Q����������>����ei�a��.8�sN2+�OR:�-*��JN���� !��ײ���>aB�d[̈́-���Ԏ2�
4�#|�ٲ7To��1mz&t�{�Z��� �(�ݖ�1��U/n9m? F��1�Bf���6DǬ�1KdR�.F�*AN�Ȅ�&M7jJ\�S<L�U�Θ䮮@�"���(��4G��Ah��|$�T�����q��D��jJ�����5�HKUm0�R��� Ö�V@��Ym )}�%�&&�\�D�í�^Z>+�lD,�B�Cz̃�I�ޙ�"j��@ �;:�V E����H�
S�M�����"j�&K�UG8�$�L;���n\!&	Y����Ra���z�~ّ��je�7�j��T��wF�"�.� ��r�$^7�ҭ����Gљ�����{U�nد���#c4�� -E�BZn�0�@��Q �zƔ���Y��
�7]a����!3�D^���̎c�� ��h���D���}��&V-(0B
�i`a6�������{M�a�I;P��J,1�Y]<��Xϫ
7�]�-4�VE����p�ME�6(��V�n��r7`!%�t���7�$e4*A�Z͠T�'b����lW
Y}���`p�BA@��M_��4�aZq����d#`e7�倰�MXd�`�f�B��~$#26s\�18!*ԊYQ��!�
��`|f�8�.Od�0�Hq�yd�� ��jB���QC"B.=��5ȡ3��7###Sg�7���	AN�KV6�1b��j��
�%�Q���5�f��J��=�"�@/��t�; ���(�s���g�i��6��j֨5����� W��
LRG�w1@��g�ȡ���|5�hcB+�a$�\΂�GA�@����-[���w�V���m���j���U��RmK�b���,�r�o@����edKT��'���3c�@����́�����7E��2"�Td`+=Mt�^/��=��ZV�P�0QR�̺t����(k
��U�R�J�n���l!xC��`X������@Sw�ݬ�)*Z�
,T�H@��[�M �uT��i9K9p��.���D���R$��8o-�G�Vtd%Λm�l�؄P��Me�Zp���Xi\��D�e�{pY-M6&مR� �0�.Ѥ��2��u�l^��%gbf*}ң����<G�E����W����Î��(���<Ivn)�8L��v�r�	�~ք�x}��v�E~)P�F!�r��8�D�F�Fp���U-�$A%QG�Ee�H���T�"����H��4�qn+MW%ܐ�G������b�x!�� �`��	x�iA2���#&¨嵋*�T%�8���R�������}��!�\�Ţ=�d��ŋV���;*	$gEƎ��y
�rb4��N̥N��"I��i�����z��d`��OW�'�&
����4z�T�?bb�	#�������,��� x� �.\�Wi�E%�$Fkh0p����nB���>&�[��@�_3�w'��`L���x��Ы.��B0A�E ��ۏ4�~�\�q��d,Y��6�r�H�O��Bx@9u=O������G;��3n�$���_V�0+p�dϜ2(g;��Ԓ$��0"E��.��ܽ�ܽ�b�Pqe�����;�������mAV0��`��*d��!a(�$�R�KX���Ɲ@ߑՁ�qB�m@^v�y�E�_"� �Tc�IO*���a�0�P�S���V�/ۭ' �4�4yto��nt��^ �9\7�PD�ٖ`�1J�9���f�Y���g;8�% ��t�Q�FH�.�"gE'��k�0(,0I�ʢ�&B�EDJʁ�P0��[��J����-cEE����Z-�Y/�,�.�c:��[�V��q�	�$�Ɗ3	KU��(|G���We�+8̢�#�����v�SF��h�����¸l�:�yې0/e������$�}��$� 4+��y�j�FM�E� 5!r.I�(U蓆f�]v/�=F_��J5dCCܴ����@Y�X��2����gl���w�Đ�y��_x�A.����Z�4�f�h a(���P�Q%Zƌ
�XK����ő�-�
��h�b��^G����ቄJi�ڛi;Jj���
EҴ RSd����&.�Gvm���#�f1�ũ��N^3��C-�C�p�Gb H=����냼FD�a��4�t����Xr��y��V�� ��ǽn,Y���hTQ,��DD9�p�O ?T�,��e���V:��$0L$̧�<d���\�A`%2��r�˙PƗ�*����t�7��!cA@w�	��h�#a�!kJ
%,�@PTF(`� �t��B�B�RO�$��§P�N^!B�6�@��P`d�#�=�}$��CX��#�^{āhA�H�&袑����q��$�Y �_����84M�Z(�%P?`	Xo*6# �fpܪ%�z�x`�.�ifᄂ�H�b,��^$�I����Ć�.("PB�����l�]`�ۗ*fmR�8	b��N�^�^��X*3�����0/SB�� ��)T�@H�vcW�
Gߐs
Z*�"��P�R����N+(Mk-:�AI�B��G-��yH����h�hg/�H�Lc3ב"�z�2�jG�Ja��ɒK��9�s!�X)tG��}F>��9��, m���*q3�j��.�vD�0�H��H�H�J�7_zc#�P�q$�g�.���x,K���s�Y��+�a4w�M�$f�b@B�p���O����$�Pg`�Ȍ0G�"�	���#��*/��H�Y�{CX�E ��&#r�h2yN_6e]�A���R�C�)VQB�aX*D��.x�����J��T�g�u�튄:"�BjT�qk!������Y�ϮmF��m��A�f�(��q�����f� I
�&[�=E� �1B����
��l�r:N	§c,��-}��[}�%[�o�Q�N8��i�i�����i�DF2��Y̡��v�d%2#47|�@�K��� 1H����l�����Hk�1(�4���E��+v�ҤDX�VH*�eZ�Yjc��Ķ K��T7D@	�I�wb��v]ܲ �iJ+$h_�l�2�\�H��9�-WXL�Е/�HH!? �	�0�jK��q�V����F�BF4����uӸ�ܵ�C���7$$�`
�א�LH1�E���^����I��cA#aQ^k@H�du�D&`6�Fɐ���#qdW���^��BE��-Y�+�!J `��lj$Z{ة���	�v>�;jM��#!��X�.��֟!Z.࠭t���\%.�P��*JH�P�"v�����,�#74Rh���7y�)�(�XX�Y�2��\�ꥢG���X��m�#��� ��ܠ��II�MK��(��&��8�&�W9�B��mYmz�g�3��V���� e�M��az���AUQ@ �[[6ZP�nE��1-3��!�ى��oF&aa�t��} �����]_���n�-��h���EV(n0@i������k��6�V��)�v��s{!H�BZ�߄��y4��[�Y���&��rh�E����-V��Da�g(0ʂ����ȿ-���Kh`�@qJ��^�K�j>�qsL��:�F{C�7Г�q���� ��Ā��\�=r����J�6&�4�va��#Ҧ�x�h��<�j 'U�l��Eb,�`m�x���\P4g��K��71R#�SJ�G|u�>r�"�7�ۘW� Rgڠa�CV���E��C�\!Àw���{-��SP��b A�4Lr��*�H�K�{�P��p�\�ͤ/T����1v��D4�mX8� h�ʠfn�(�yeTّ (��5P�"��K��++yn[p�M��;���L�/�@)��d�4n]�01htE�u��n�F�YC�+|8D��pIAb�RH$�q�X�X�ɩ���pV��;������H&�*҄���al%���U�rUT�V5W� ��(JHf7�	�<��R\�M�-Ѿ#���3��c$1d��3JAGp��~``S.Xjo�0(.k���-/�7 D�0��%P�x0z~+3�uM -,���%y�+�`�QV�:q�>9:�3ٕ8��uвK�%0V@�BD�M ���k9ΔiF�����r���
�&*���]����������6�5JI.Q:���5�c��7�!4��z@`b��y�A��G2%-)n6��⡭���w���W����y�É*���e �0�Y`�u[���n
;<4<��#�!�s=y}��	�̀L�=�7_�h^����Gwr�"Nr6�#�x���M
t���^Z���6�it�㺒��I��!sqr��ng������nӕ�/��<筰�+�~��@����J�X�*iC�(�F�~02�p#M��bHa�3f[e�~�AQ�J
��+���(9ΥM즤0rϵ{� I�H{�m@7�NQ+7A,�h��Y]ٵ�	��!��)���z
�2Q"h���5 ����![���$��C���,e+�����1�w�n��Ձ���Ƭ�UB��D<|��
�BHt�(##�q�/�bT��~�&i��]�HLEaO�
�jH��	PT�u<���6�K�H�Ra���p�~7�<הD8PB�$�ɕͦ�V�펒d4/9MV%=~b��i;��F\��7��z�ߐ��-��:34���ȯ�!Z���b��I�O�j�vm�}�U��_>X�lOpm"E>YS�?f~�w��������a@�OZ�|ǟ^B� �I��o�̏�h�{�V��U^�Uz�	o/�AQ���`��9� ��.* ���!�4!�R��a/f��]��BC �
D