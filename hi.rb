require 'rubygems'
require 'sinatra'
require 'json'
set :server, :thin
connections = []

get '/checkvin/:vin' do
	if params[:vin].length != 17
		return "Wrong length!"
	end 

	vin_array = []

	##New way to calc
	vin = params['vin'];
	sum = CheckFist12DigitSumm(vin);
	chk = GetCheckDigit(vin)

	for i in 0..9
   	    ii = i * 6;	
   	    for j in 0..9
   	    	jj = j * 5;
   	    	for k in 0..9
   	    		kk = k * 4;
   	    		for l in 0..9
   	    			ll = l * 3;
   	    			sum2 = sum + ii + jj + kk + ll - chk;
   	    			rest = 11 - sum2 % 11;
                    if rest == 11 
                       rest = 0;
                    end
					if rest % 2 == 0
                        vin_array << "#{vin[0..11]}#{i}#{j}#{k}#{l}#{rest/2}"
                    elsif  rest + 11 <= 18 
                        vin_array << "#{vin[0..11]}#{i}#{j}#{k}#{l}#{(rest+11)/2}"
                    end
   	    		end
   	    	end 
   	   	end
	end

  content_type :json
  return vin_array.to_json
end

public def is_number?
    true if Float(self) rescue false
end

def CheckFist12DigitSumm(vin)
	vin = vin.upcase
	length = vin.length
	sum = 0
	transliteration = ({"A" => 1, "B"=>2, "C"=>3, "D"=>4, "E"=>5, "F"=>6, "G"=>7, "H"=>8, "J"=>1, "K"=>2, "L"=>3, "M"=>4, "N"=>5, "P"=>7, "R"=>9, "S"=>2, "T"=>3, "U"=>4, "V"=>5, "W"=>6, "X"=>7, "Y"=>8, "Z"=>9});
	weights = [8,7,6,5,4,3,2,10,0,9,8,7,6,5,4,3,2];

	for x in 0..11
            char = vin[x] 
            if char.is_number?
                sum += char.to_i * weights[x].to_i
            else
                sum += transliteration[char].to_i * weights[x].to_i
        	end
    end
    return sum
end 

def GetCheckDigit(vin)
	vin = vin.upcase;
	checkdigit = vin[8] == 'X' ? 10 : vin[8]
	return checkdigit.to_i
end